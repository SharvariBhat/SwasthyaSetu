const medicalRecordModel = require('../models/medicalRecordModel');
const fs = require('fs');
const path = require('path');

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
    // Accept both camelCase and snake_case
    const {
      recordType, record_type,
      recordDate, record_date,
      diagnosis,
      doctorName, doctor_name,
      hospitalName, hospital_name,
      notes
    } = req.body;

    const finalRecordType = recordType || record_type;
    const finalRecordDate = recordDate || record_date;
    const finalDoctorName = doctorName || doctor_name;
    const finalHospitalName = hospitalName || hospital_name;

    // Basic validation
    if (!finalRecordType || !finalRecordDate) {
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
      recordType: finalRecordType,
      recordDate: finalRecordDate,
      diagnosis,
      doctorName: finalDoctorName,
      hospitalName: finalHospitalName,
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
      recordType, record_type,
      recordDate, record_date,
      diagnosis,
      doctorName, doctor_name,
      hospitalName, hospital_name,
      notes
    } = req.body;

    const finalRecordType = recordType || record_type;
    const finalRecordDate = recordDate || record_date;
    const finalDoctorName = doctorName || doctor_name;
    const finalHospitalName = hospitalName || hospital_name;

    // Check if record exists and belongs to user
    const existingRecord = await medicalRecordModel.getMedicalRecordById(recordId, userId);
    if (!existingRecord) {
      return res.status(404).json({
        success: false,
        message: 'Medical record not found'
      });
    }

    // Basic validation
    if (!finalRecordType || !finalRecordDate) {
      return res.status(400).json({
        success: false,
        message: 'Record type and record date are required'
      });
    }

    const updateData = {
      recordType: finalRecordType,
      recordDate: finalRecordDate,
      diagnosis,
      doctorName: finalDoctorName,
      hospitalName: finalHospitalName,
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
    if (deletedRecord && deletedRecord.file_path) {
      try {
        if (fs.existsSync(deletedRecord.file_path)) {
          fs.unlinkSync(deletedRecord.file_path);
        }
      } catch (fileError) {
        console.error('Error deleting physical file:', fileError);
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

    const record = await medicalRecordModel.getMedicalRecordByIdRaw(recordId, userId);
    if (!record) {
      return res.status(404).json({
        success: false,
        message: 'Medical record not found'
      });
    }

    if (!record.file_path || !fs.existsSync(record.file_path)) {
      return res.status(404).json({
        success: false,
        message: 'File not found'
      });
    }

    // Set appropriate headers for file download
    res.setHeader('Content-Disposition', `attachment; filename="${record.file_name}"`);
    res.setHeader('Content-Type', record.file_type || 'application/octet-stream');
    
    // Stream the file
    const fileStream = fs.createReadStream(record.file_path);
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

module.exports = {
  getMedicalRecords,
  uploadMedicalRecord,
  getMedicalRecord,
  updateMedicalRecord,
  deleteMedicalRecord,
  downloadFile
};