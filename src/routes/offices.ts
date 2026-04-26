import { Router } from 'express';
import { requireAuth, requireRole } from '../middleware/auth';

const router = Router();
router.use(requireAuth, requireRole('owner', 'superadmin'));

router.get('/', (_req, res) => res.json({ status: 'success', data: { offices: [] } }));
router.post('/', (_req, res) => res.status(201).json({ status: 'success', data: { office: {} } }));
router.get('/:officeId', (_req, res) => res.json({ status: 'success', data: { office: {} } }));
router.put('/:officeId', (_req, res) => res.json({ status: 'success', data: { office: {} } }));
router.delete('/:officeId', (_req, res) => res.json({ status: 'success', data: { message: 'Office deleted' } }));
router.get('/:officeId/team', (_req, res) => res.json({ status: 'success', data: { members: [] } }));
router.post('/:officeId/team', (_req, res) => res.status(201).json({ status: 'success', data: { member: {} } }));
router.put('/:officeId/team/:memberId', (_req, res) => res.json({ status: 'success', data: { member: {} } }));
router.delete('/:officeId/team/:memberId', (_req, res) => res.json({ status: 'success', data: { message: 'Member removed' } }));
router.get('/:officeId/production', (_req, res) => res.json({ status: 'success', data: { metrics: {} } }));
router.get('/:officeId/irs-feed', (_req, res) => res.json({ status: 'success', data: { events: [] } }));
router.get('/:officeId/settings', (_req, res) => res.json({ status: 'success', data: { settings: {} } }));
router.put('/:officeId/settings', (_req, res) => res.json({ status: 'success', data: { settings: {} } }));

export default router;
