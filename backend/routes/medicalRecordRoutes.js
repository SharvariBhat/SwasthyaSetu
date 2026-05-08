const express = require('express');
const router = express.Router();
const medicalRecordController = require('../controllers/medicalRecordController');
const authMiddleware = require('../middleware/authMiddleware');
const { upload, handleMulterError } = require('../middleware/uploadMiddleware');

// GET /api/medical-records - Get all medical records for user
router.get('/', authMiddleware, medicalRecordController.getMedicalRecords);

// POST /api/medical-records/upload - Upload new medical record with file
router.post('/upload', 
  authMiddleware,
  upload.single('file'), 
  medicalRecordController.uploadMedicalRecord
);

// GET /api/medical-records/:id - Get specific medical record
router.get('/:id', authMiddleware, medicalRecordController.getMedicalRecord);

// PUT /api/medical-records/:id - Update medical record (metadata only)
router.put('/:id', authMiddleware, medicalRecordController.updateMedicalRecord);

// DELETE /api/medical-records/:id - Delete medical record
router.delete('/:id', authMiddleware, medicalRecordController.deleteMedicalRecord);

// GET /api/medical-records/:id/download - Download file
router.get('/:id/download', authMiddleware, medicalRecordController.downloadFile);

module.exports = router;