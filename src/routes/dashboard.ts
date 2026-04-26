import { Router } from 'express';
import { requireAuth } from '../middleware/auth';

const router = Router();
router.use(requireAuth);

router.get('/', (_req, res) => res.json({ status: 'success', data: { dashboard: {} } }));
router.get('/stats', (_req, res) => res.json({ status: 'success', data: { stats: {} } }));
router.get('/alerts', (_req, res) => res.json({ status: 'success', data: { alerts: [] } }));
router.get('/production', (_req, res) => res.json({ status: 'success', data: { production: {} } }));

export default router;
