import { Router } from 'express';
import { requireAuth } from '../middleware/auth';

const router = Router();

router.get('/login', (_req, res) => res.json({ page: 'login' }));
router.post('/login', (_req, res) => res.json({ status: 'success', data: { token: '<jwt>', refreshToken: '<refresh>' } }));
router.get('/signup', (_req, res) => res.json({ page: 'signup' }));
router.post('/signup', (_req, res) => res.status(201).json({ status: 'success', data: { user: {}, token: '<jwt>' } }));
router.get('/forgot-password', (_req, res) => res.json({ page: 'forgot-password' }));
router.post('/forgot-password', (_req, res) => res.json({ status: 'success', data: { message: 'Reset email sent' } }));
router.get('/reset-password/:token', (_req, res) => res.json({ page: 'reset-password' }));
router.post('/reset-password/:token', (_req, res) => res.json({ status: 'success', data: { message: 'Password reset' } }));
router.get('/verify-email/:token', (_req, res) => res.redirect('/app/dashboard'));
router.post('/logout', requireAuth, (_req, res) => res.json({ status: 'success' }));
router.get('/mfa/setup', requireAuth, (_req, res) => res.json({ page: 'mfa-setup' }));
router.post('/mfa/setup', requireAuth, (_req, res) => res.json({ status: 'success', data: { qrCode: '<qr>', backupCodes: [] } }));
router.post('/mfa/verify', (_req, res) => res.json({ status: 'success', data: { token: '<jwt>' } }));
router.post('/refresh-token', (_req, res) => res.json({ status: 'success', data: { token: '<jwt>', refreshToken: '<refresh>' } }));

export default router;
