import { Router } from 'express';
import { requireAuth } from '../middleware/auth';

const router = Router();
router.use(requireAuth);

router.get('/dashboard', (_req, res) => res.json({ status: 'success', data: { dashboard: {} } }));
router.get('/returns', (_req, res) => res.json({ status: 'success', data: { returns: [] } }));
router.get('/returns/:returnId', (_req, res) => res.json({ status: 'success', data: { return: {} } }));
router.get('/documents', (_req, res) => res.json({ status: 'success', data: { documents: [] } }));
router.post('/documents', (_req, res) => res.status(201).json({ status: 'success', data: { document: {} } }));
router.delete('/documents/:docId', (_req, res) => res.json({ status: 'success', data: { message: 'Document deleted' } }));
router.get('/messages', (_req, res) => res.json({ status: 'success', data: { messages: [] } }));
router.post('/messages', (_req, res) => res.status(201).json({ status: 'success', data: { message: {} } }));
router.get('/messages/:messageId', (_req, res) => res.json({ status: 'success', data: { thread: [] } }));
router.get('/profile', (_req, res) => res.json({ status: 'success', data: { profile: {} } }));
router.put('/profile', (_req, res) => res.json({ status: 'success', data: { profile: {} } }));
router.get('/settings', (_req, res) => res.json({ status: 'success', data: { settings: {} } }));
router.put('/settings', (_req, res) => res.json({ status: 'success', data: { settings: {} } }));
router.get('/irs-summary', (_req, res) => res.json({ status: 'success', data: { summary: {} } }));
router.get('/refund-status', (_req, res) => res.json({ status: 'success', data: { refund: {} } }));

// Self-service wizard
router.get('/wizard', (_req, res) => res.json({ status: 'success', data: { wizard: {} } }));
router.get('/wizard/step/:step', (_req, res) => res.json({ status: 'success', data: { step: {} } }));
router.post('/wizard/step/:step', (_req, res) => res.json({ status: 'success', data: { next: {} } }));
router.get('/wizard/preview', (_req, res) => res.json({ status: 'success', data: { preview: {} } }));
router.post('/wizard/submit', (_req, res) => res.json({ status: 'success', data: { confirmation: {} } }));
router.get('/wizard/download', (_req, res) => res.json({ status: 'success', data: { pdf: '<url>' } }));

export default router;
