import { Router } from 'express';
import { requireAuth } from '../middleware/auth';

const router = Router();
router.use(requireAuth);

router.get('/feed', (_req, res) => res.json({ status: 'success', data: { events: [] } }));
router.get('/feed/:feedId', (_req, res) => res.json({ status: 'success', data: { event: {} } }));
router.get('/alerts', (_req, res) => res.json({ status: 'success', data: { alerts: [] } }));
router.get('/alerts/:alertId', (_req, res) => res.json({ status: 'success', data: { alert: {} } }));
router.post('/alerts/:alertId/acknowledge', (_req, res) => res.json({ status: 'success', data: { alert: {} } }));
router.get('/tc-codes', (_req, res) => res.json({ status: 'success', data: { codes: [] } }));
router.get('/tc-codes/:tcCode', (_req, res) => res.json({ status: 'success', data: { definition: {} } }));
router.get('/transcript/:clientId', (_req, res) => res.json({ status: 'success', data: { transcript: {} } }));
router.post('/transcript/:clientId/refresh', (_req, res) => res.json({ status: 'success', data: { transcript: {} } }));
router.get('/holds', (_req, res) => res.json({ status: 'success', data: { holds: [] } }));
router.get('/holds/:holdId', (_req, res) => res.json({ status: 'success', data: { hold: {} } }));
router.post('/compliance-check', (_req, res) => res.json({ status: 'success', data: { results: {} } }));

export default router;
