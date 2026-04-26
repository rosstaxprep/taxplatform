import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';

import authRoutes from './routes/auth';
import dashboardRoutes from './routes/dashboard';
import clientRoutes from './routes/clients';
import returnRoutes from './routes/returns';
import irsRoutes from './routes/irs';
import officeRoutes from './routes/offices';
import settingsRoutes from './routes/settings';
import adminRoutes from './routes/admin';
import clientPortalRoutes from './routes/clientPortal';

const app = express();
const PORT = process.env.PORT || 3000;

// Security & parsing
app.use(helmet());
app.use(cors({ origin: process.env.ALLOWED_ORIGIN || 'https://primeweb.app', credentials: true }));
app.use(express.json());

// Rate limiting
const publicLimiter = rateLimit({ windowMs: 60 * 60 * 1000, max: 100 });
const authLimiter = rateLimit({ windowMs: 60 * 60 * 1000, max: 1000 });
const adminLimiter = rateLimit({ windowMs: 60 * 60 * 1000, max: 10000 });

// Health check
app.get('/health', (_req, res) => res.json({ status: 'ok', version: '1.0.0' }));
app.get('/status', publicLimiter, (_req, res) => res.json({ status: 'operational' }));

// Public pages
app.get('/', publicLimiter, (_req, res) => res.json({ page: 'landing' }));
for (const page of ['/features', '/pricing', '/security', '/blog', '/contact', '/demo', '/docs']) {
  app.get(page, publicLimiter, (_req, res) => res.json({ page }));
}
app.get('/blog/:slug', publicLimiter, (_req, res) => res.json({ page: 'blog', slug: _req.params.slug }));
app.post('/contact', publicLimiter, (_req, res) => res.json({ status: 'success' }));
app.post('/demo', publicLimiter, (_req, res) => res.json({ status: 'success' }));

// Auth routes
app.use('/auth', publicLimiter, authRoutes);

// App routes (office dashboard)
app.use('/app/dashboard', authLimiter, dashboardRoutes);
app.use('/app/clients', authLimiter, clientRoutes);
app.use('/app/returns', authLimiter, returnRoutes);
app.use('/app/irs', authLimiter, irsRoutes);
app.use('/app/offices', authLimiter, officeRoutes);
app.use('/app/settings', authLimiter, settingsRoutes);

// Client portal
app.use('/client', authLimiter, clientPortalRoutes);

// Admin panel
app.use('/admin', adminLimiter, adminRoutes);

// REST API aliases (legacy support)
app.use('/api/auth', publicLimiter, authRoutes);
app.use('/api/clients', authLimiter, clientRoutes);
app.use('/api/returns', authLimiter, returnRoutes);
app.use('/api/irs', authLimiter, irsRoutes);
app.use('/api/offices', authLimiter, officeRoutes);

// 404 handler
app.use((_req, res) => res.status(404).json({ status: 'error', error: { code: 'NOT_FOUND', message: 'Route not found' } }));

// Error handler
app.use((err: Error, _req: express.Request, res: express.Response, _next: express.NextFunction) => {
  console.error(err);
  res.status(500).json({ status: 'error', error: { code: 'INTERNAL_ERROR', message: 'Internal server error' } });
});

app.listen(PORT, () => console.log(`PrimeWeb API running on port ${PORT} [${process.env.NODE_ENV}]`));

export default app;
