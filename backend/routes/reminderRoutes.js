const express = require('express');
const router = express.Router();
const reminderController = require('../controllers/reminderController');
const authMiddleware = require('../middleware/authMiddleware');

// All reminder routes require authentication
router.use(authMiddleware);

// GET /api/reminders - Get all reminders for user
router.get('/', reminderController.getReminders);

// POST /api/reminders - Create new reminder
router.post('/', reminderController.addReminder);

// GET /api/reminders/:id - Get specific reminder
router.get('/:id', reminderController.getReminder);

// PUT /api/reminders/:id - Update reminder
router.put('/:id', reminderController.updateReminder);

// DELETE /api/reminders/:id - Delete reminder
router.delete('/:id', reminderController.deleteReminder);

module.exports = router;
