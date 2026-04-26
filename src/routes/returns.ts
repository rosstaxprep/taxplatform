import { Router } from 'express';
import { requireAuth } from '../middleware/auth';

const router = Router();
router.use(requireAuth);

router.get('/', (_req, res) => res.json({ status: 'success', data: { returns: [] } }));
router.post('/', (_req, res) => res.status(201).json({ status: 'success', data: { return: {} } }));
router.get('/:returnId', (_req, res) => res.json({ status: 'success', data: { return: {} } }));
router.put('/:returnId', (_req, res) => res.json({ status: 'success', data: { return: {} } }));
router.delete('/:returnId', (_req, res) => res.json({ status: 'success', data: { message: 'Return deleted' } }));
router.get('/:returnId/summary', (_req, res) => res.json({ status: 'success', data: { summary: {} } }));
router.get('/:returnId/forms', (_req, res) => res.json({ status: 'success', data: { forms: [] } }));
router.get('/:returnId/forms/:formId', (_req, res) => res.json({ status: 'success', data: { form: {} } }));
router.put('/:returnId/forms/:formId', (_req, res) => res.json({ status: 'success', data: { form: {} } }));
router.post('/:returnId/calculate', (_req, res) => res.json({ status: 'success', data: { calculations: {} } }));
router.post('/:returnId/validate', (_req, res) => res.json({ status: 'success', data: { errors: [] } }));
router.post('/:returnId/file', (_req, res) => res.json({ status: 'success', data: { filingConfirmation: {} } }));
router.get('/:returnId/preview', (_req, res) => res.json({ status: 'success', data: { pdf: '<url>' } }));
router.get('/:returnId/transcript', (_req, res) => res.json({ status: 'success', data: { transcript: {} } }));
router.get('/:returnId/history', (_req, res) => res.json({ status: 'success', data: { history: [] } }));

// Schedules
for (const sched of ['schedule-a', 'schedule-c', 'schedule-d', 'schedule-e']) {
  router.get(`/:returnId/${sched}`, (_req, res) => res.json({ status: 'success', data: { [sched]: {} } }));
  router.put(`/:returnId/${sched}`, (_req, res) => res.json({ status: 'success', data: { [sched]: {} } }));
}

export default router;
