const express = require('express');
const router = express.Router();
const symptomController = require('../controllers/symptomController');
const authMiddleware = require('../middleware/authMiddleware');

// All symptom routes require authentication
router.use(authMiddleware);

// GET /api/symptoms - Get all symptom logs for user
router.get('/', symptomController.getSymptoms);

// POST /api/symptoms - Log new symptom
router.post('/', symptomController.addSymptom);

// GET /api/symptoms/:id - Get specific symptom log
router.get('/:id', symptomController.getSymptom);

// DELETE /api/symptoms/:id - Delete symptom log
router.delete('/:id', symptomController.deleteSymptom);

module.exports = router;
