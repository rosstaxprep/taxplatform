import { Router } from 'express';
import { requireAuth } from '../middleware/auth';

const router = Router();
router.use(requireAuth);

router.get('/', (_req, res) => res.json({ status: 'success', data: { clients: [] } }));
router.post('/', (_req, res) => res.status(201).json({ status: 'success', data: { client: {} } }));
router.post('/bulk-import', (_req, res) => res.json({ status: 'success', data: { imported: 0 } }));
router.get('/:clientId', (_req, res) => res.json({ status: 'success', data: { client: {} } }));
router.put('/:clientId', (_req, res) => res.json({ status: 'success', data: { client: {} } }));
router.delete('/:clientId', (_req, res) => res.json({ status: 'success', data: { message: 'Client deleted' } }));
router.get('/:clientId/returns', (_req, res) => res.json({ status: 'success', data: { returns: [] } }));
router.get('/:clientId/documents', (_req, res) => res.json({ status: 'success', data: { documents: [] } }));
router.post('/:clientId/documents', (_req, res) => res.status(201).json({ status: 'success', data: { document: {} } }));
router.get('/:clientId/messages', (_req, res) => res.json({ status: 'success', data: { messages: [] } }));
router.post('/:clientId/messages', (_req, res) => res.status(201).json({ status: 'success', data: { message: {} } }));

export default router;
