const medicalRecordModel = require('../models/medicalRecordModel');
const fs = require('fs');
const path = require('path');
const ocrService = require('../utils/ocrService');

const getMedicalRecords = async (req, res) => {
  try {
    const userId = req.user.id;
    const records = await medicalRecordModel.getMedicalRecordsByUserId(userId);
    
    res.status(200).json({
      success: true,
      message: 'Medical records retrieved successfully',
      data: records
    });
  } catch (error) {
    console.error('Error in getMedicalRecords:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message
    });
  }
};

const uploadMedicalRecord = async (req, res) => {
  try {
    const userId = req.user.id;
    const {
      recordType,
      recordDate,
      diagnosis,
      doctorName,
      hospitalName,
      notes
    } = req.body;

    // Basic validation
    if (!recordType || !recordDate) {
      return res.status(400).json({
        success: false,
        message: 'Record type and record date are required'
      });
    }

    let filePath = null;
    let fileName = null;
    let fileSize = null;
    let fileType = null;

    // Handle file upload if present
    if (req.file) {
      filePath = req.file.path;
      fileName = req.file.originalname;
      fileSize = req.file.size;
      fileType = req.file.mimetype;
    }

    const recordData = {
      userId,
      recordType,
      recordDate,
      diagnosis,
      doctorName,
      hospitalName,
      filePath,
      fileName,
      fileSize,
      fileType,
      notes
    };

    const newRecord = await medicalRecordModel.createMedicalRecord(recordData);
    
    res.status(201).json({
      success: true,
      message: 'Medical record uploaded successfully',
      data: newRecord
    });
  } catch (error) {
    console.error('Error in uploadMedicalRecord:', error);
    
    // Clean up uploaded file if there was an error
    if (req.file && req.file.path) {
      try {
        fs.unlinkSync(req.file.path);
      } catch (unlinkError) {
        console.error('Error deleting uploaded file:', unlinkError);
      }
    }
    
    res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message
    });
  }
};

const getMedicalRecord = async (req, res) => {
  try {
    const userId = req.user.id;
    const recordId = req.params.id;

    const record = await medicalRecordModel.getMedicalRecordById(recordId, userId);
    if (!record) {
      return res.status(404).json({
        success: false,
        message: 'Medical record not found'
      });
    }
    
    res.status(200).json({
      success: true,
      message: 'Medical record retrieved successfully',
      data: record
    });
  } catch (error) {
    console.error('Error in getMedicalRecord:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message
    });
  }
};

const updateMedicalRecord = async (req, res) => {
  try {
    const userId = req.user.id;
    const recordId = req.params.id;
    const {
      recordType,
      recordDate,
      diagnosis,
      doctorName,
      hospitalName,
      notes
    } = req.body;

    // Check if record exists and belongs to user
    const existingRecord = await medicalRecordModel.getMedicalRecordById(recordId, userId);
    if (!existingRecord) {
      return res.status(404).json({
        success: false,
        message: 'Medical record not found'
      });
    }

    // Basic validation
    if (!recordType || !recordDate) {
      return res.status(400).json({
        success: false,
        message: 'Record type and record date are required'
      });
    }

    const updateData = {
      recordType,
      recordDate,
      diagnosis,
      doctorName,
      hospitalName,
      notes
    };

    const updatedRecord = await medicalRecordModel.updateMedicalRecord(recordId, userId, updateData);
    
    res.status(200).json({
      success: true,
      message: 'Medical record updated successfully',
      data: updatedRecord
    });
  } catch (error) {
    console.error('Error in updateMedicalRecord:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message
    });
  }
};

const deleteMedicalRecord = async (req, res) => {
  try {
    const userId = req.user.id;
    const recordId = req.params.id;

    // Check if record exists and belongs to user
    const existingRecord = await medicalRecordModel.getMedicalRecordById(recordId, userId);
    if (!existingRecord) {
      return res.status(404).json({
        success: false,
        message: 'Medical record not found'
      });
    }

    const deletedRecord = await medicalRecordModel.deleteMedicalRecord(recordId, userId);
    
    // Delete the physical file if it exists
    if (deletedRecord && deletedRecord.filePath) {
      try {
        if (fs.existsSync(deletedRecord.filePath)) {
          fs.unlinkSync(deletedRecord.filePath);
        }
      } catch (fileError) {
        console.error('Error deleting physical file:', fileError);
        // Don't fail the request if file deletion fails
      }
    }
    
    res.status(200).json({
      success: true,
      message: 'Medical record deleted successfully'
    });
  } catch (error) {
    console.error('Error in deleteMedicalRecord:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message
    });
  }
};

const downloadFile = async (req, res) => {
  try {
    const userId = req.user.id;
    const recordId = req.params.id;

    const record = await medicalRecordModel.getMedicalRecordById(recordId, userId);
    if (!record) {
      return res.status(404).json({
        success: false,
        message: 'Medical record not found'
      });
    }

    if (!record.filePath || !fs.existsSync(record.filePath)) {
      return res.status(404).json({
        success: false,
        message: 'File not found'
      });
    }

    // Set appropriate headers for file download
    res.setHeader('Content-Disposition', `attachment; filename="${record.fileName}"`);
    res.setHeader('Content-Type', record.fileType || 'application/octet-stream');
    
    // Stream the file
    const fileStream = fs.createReadStream(record.filePath);
    fileStream.pipe(res);
  } catch (error) {
    console.error('Error in downloadFile:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message
    });
  }
};

const analyzeMedicalRecord = async (req, res) => {
  try {
    const userId = req.user.id;
    const recordId = req.params.id;

    // Check if record exists and belongs to user
    const record = await medicalRecordModel.getMedicalRecordById(recordId, userId);
    if (!record) {
      return res.status(404).json({
        success: false,
        message: 'Medical record not found'
      });
    }

    // Check if file exists
    if (!record.filePath || !fs.existsSync(record.filePath)) {
      return res.status(400).json({
        success: false,
        message: 'No file available for analysis'
      });
    }

    console.log(`[ANALYZE] Starting OCR analysis for record ID: ${recordId}`);
    console.log(`[ANALYZE] File: ${record.fileName}`);

    // Perform OCR using Tesseract.js
    let extractedText = '';
    let confidence = 0;

    try {
      const ocrResult = await ocrService.extractTextFromImage(
        record.filePath,
        record.fileType
      );
      extractedText = ocrResult.text;
      confidence = ocrResult.confidence;
    } catch (ocrError) {
      console.error('[ANALYZE] OCR extraction failed:', ocrError.message);
      
      // Return error response with details
      return res.status(400).json({
        success: false,
        message: 'OCR extraction failed',
        error: ocrError.message,
        details: {
          recordId: record.id,
          fileName: record.fileName,
          fileType: record.fileType
        }
      });
    }

    // If no text was extracted
    if (!extractedText || !extractedText.trim()) {
      console.log('[ANALYZE] No text found in image');
      return res.status(200).json({
        success: true,
        message: 'OCR completed - no text found in image',
        data: {
          recordId: record.id,
          fileName: record.fileName,
          fileType: record.fileType,
          extractedText: '',
          textLength: 0,
          wordCount: 0,
          confidence: confidence,
          analysis: {
            status: 'ocr_completed_no_text',
            timestamp: new Date().toISOString()
          }
        }
      });
    }

    // Clean up the extracted text
    const cleanedText = ocrService.cleanExtractedText(extractedText);
    const wordCount = ocrService.getWordCount(cleanedText);

    console.log(`[ANALYZE] OCR analysis completed successfully`);
    console.log(`[ANALYZE] Extracted text length: ${cleanedText.length} characters`);
    console.log(`[ANALYZE] Word count: ${wordCount}`);
    console.log(`[ANALYZE] Confidence: ${confidence}%`);

    // Return the extracted text
    res.status(200).json({
      success: true,
      message: 'Text extracted successfully',
      data: {
        recordId: record.id,
        fileName: record.fileName,
        fileType: record.fileType,
        extractedText: cleanedText,
        textLength: cleanedText.length,
        wordCount: wordCount,
        confidence: confidence,
        analysis: {
          status: 'ocr_completed',
          timestamp: new Date().toISOString()
        }
      }
    });

  } catch (error) {
    console.error('[ANALYZE] Error in analyzeMedicalRecord:', error.message);
    
    res.status(500).json({
      success: false,
      message: 'Error analyzing medical record',
      error: error.message
    });
  }
};

module.exports = {
  getMedicalRecords,
  uploadMedicalRecord,
  getMedicalRecord,
  updateMedicalRecord,
  deleteMedicalRecord,
  downloadFile,
  analyzeMedicalRecord
};