const medicineModel = require('../models/medicineModel');
const reminderModel = require('../models/reminderModel');

const getMedicines = async (req, res) => {
  try {
    const userId = req.user.id;
    const medicines = await medicineModel.getMedicinesByUserId(userId);
    
    res.status(200).json({
      success: true,
      message: 'Medicines retrieved successfully',
      data: medicines
    });
  } catch (error) {
    console.error('Error in getMedicines:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

const addMedicine = async (req, res) => {
  try {
    const userId = req.user.id;
    // Accept both camelCase and snake_case from frontend
    const {
      medicineName, medicine_name,
      dosage,
      timing,
      frequency,
      startDate, start_date,
      endDate, end_date,
      notes
    } = req.body;

    const finalMedicineName = medicineName || medicine_name;
    const finalStartDate = startDate || start_date;
    const finalEndDate = endDate || end_date;

    // Basic validation
    if (!finalMedicineName || !dosage || !timing || !frequency) {
      return res.status(400).json({
        success: false,
        message: 'Medicine name, dosage, timing, and frequency are required'
      });
    }

    const medicineData = {
      userId,
      medicineName: finalMedicineName,
      dosage,
      timing,
      frequency,
      startDate: finalStartDate,
      endDate: finalEndDate,
      notes
    };

    const newMedicine = await medicineModel.createMedicine(medicineData);
    
    // Automatically create a reminder for this medicine
    try {
      await reminderModel.createReminder({
        userId,
        type: 'MEDICINE',
        title: finalMedicineName,
        reminderTime: timing,
        status: 'ACTIVE',
        notes: dosage
      });
    } catch (reminderError) {
      console.error('Error creating automatic reminder:', reminderError);
      // We still return success for medicine creation even if reminder fails
    }
    
    res.status(201).json({
      success: true,
      message: 'Medicine added successfully',
      data: newMedicine
    });
  } catch (error) {
    console.error('Error in addMedicine:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message
    });
  }
};

const updateMedicine = async (req, res) => {
  try {
    const userId = req.user.id;
    const medicineId = req.params.id;
    const {
      medicineName, medicine_name,
      dosage,
      timing,
      frequency,
      startDate, start_date,
      endDate, end_date,
      notes
    } = req.body;

    const finalMedicineName = medicineName || medicine_name;
    const finalStartDate = startDate || start_date;
    const finalEndDate = endDate || end_date;

    // Check if medicine exists and belongs to user
    const existingMedicine = await medicineModel.getMedicineById(medicineId, userId);
    if (!existingMedicine) {
      return res.status(404).json({
        success: false,
        message: 'Medicine not found'
      });
    }

    // Basic validation
    if (!finalMedicineName || !dosage || !timing || !frequency) {
      return res.status(400).json({
        success: false,
        message: 'Medicine name, dosage, timing, and frequency are required'
      });
    }

    const updateData = {
      medicineName: finalMedicineName,
      dosage,
      timing,
      frequency,
      startDate: finalStartDate,
      endDate: finalEndDate,
      notes
    };

    const updatedMedicine = await medicineModel.updateMedicine(medicineId, userId, updateData);
    
    res.status(200).json({
      success: true,
      message: 'Medicine updated successfully',
      data: updatedMedicine
    });
  } catch (error) {
    console.error('Error in updateMedicine:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

const deleteMedicine = async (req, res) => {
  try {
    const userId = req.user.id;
    const medicineId = req.params.id;

    // Check if medicine exists and belongs to user
    const existingMedicine = await medicineModel.getMedicineById(medicineId, userId);
    if (!existingMedicine) {
      return res.status(404).json({
        success: false,
        message: 'Medicine not found'
      });
    }

    await medicineModel.deleteMedicine(medicineId, userId);
    
    res.status(200).json({
      success: true,
      message: 'Medicine deleted successfully'
    });
  } catch (error) {
    console.error('Error in deleteMedicine:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

const getMedicine = async (req, res) => {
  try {
    const userId = req.user.id;
    const medicineId = req.params.id;

    const medicine = await medicineModel.getMedicineById(medicineId, userId);
    if (!medicine) {
      return res.status(404).json({
        success: false,
        message: 'Medicine not found'
      });
    }
    
    res.status(200).json({
      success: true,
      message: 'Medicine retrieved successfully',
      data: medicine
    });
  } catch (error) {
    console.error('Error in getMedicine:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

module.exports = {
  getMedicines,
  addMedicine,
  updateMedicine,
  deleteMedicine,
  getMedicine
};