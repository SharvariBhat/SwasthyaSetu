const medicineModel = require('../models/medicineModel');

const getMedicines = async (req, res) => {
  try {
    const userId = req.user.id; // From JWT middleware
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
    console.log('Add medicine request received');
    console.log('User from token:', req.user);
    console.log('Request body:', req.body);
    
    const userId = req.user.id; // From JWT middleware
    const {
      medicineName,
      dosage,
      timing,
      frequency,
      startDate,
      endDate,
      notes
    } = req.body;

    // Basic validation
    if (!medicineName || !dosage || !timing || !frequency) {
      return res.status(400).json({
        success: false,
        message: 'Medicine name, dosage, timing, and frequency are required'
      });
    }

    const medicineData = {
      userId,
      medicineName,
      dosage,
      timing,
      frequency,
      startDate,
      endDate,
      notes
    };

    console.log('Medicine data to save:', medicineData);
    const newMedicine = await medicineModel.createMedicine(medicineData);
    console.log('Medicine saved successfully:', newMedicine);
    
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
    const userId = req.user.id; // From JWT middleware
    const medicineId = req.params.id;
    const {
      medicineName,
      dosage,
      timing,
      frequency,
      startDate,
      endDate,
      notes
    } = req.body;

    // Check if medicine exists and belongs to user
    const existingMedicine = await medicineModel.getMedicineById(medicineId, userId);
    if (!existingMedicine) {
      return res.status(404).json({
        success: false,
        message: 'Medicine not found'
      });
    }

    // Basic validation
    if (!medicineName || !dosage || !timing || !frequency) {
      return res.status(400).json({
        success: false,
        message: 'Medicine name, dosage, timing, and frequency are required'
      });
    }

    const updateData = {
      medicineName,
      dosage,
      timing,
      frequency,
      startDate,
      endDate,
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
    const userId = req.user.id; // From JWT middleware
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
    const userId = req.user.id; // From JWT middleware
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