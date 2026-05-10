const symptomModel = require('../models/symptomModel');

const getSymptoms = async (req, res) => {
  try {
    const userId = req.user.id;
    const symptoms = await symptomModel.getSymptomsByUserId(userId);
    
    res.status(200).json({
      success: true,
      message: 'Symptoms retrieved successfully',
      data: symptoms
    });
  } catch (error) {
    console.error('Error in getSymptoms:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

const addSymptom = async (req, res) => {
  try {
    const userId = req.user.id;
    const { symptom, severity, logDate, log_date, notes } = req.body;

    // Basic validation
    if (!symptom) {
      return res.status(400).json({
        success: false,
        message: 'Symptom description is required'
      });
    }

    const symptomData = {
      userId,
      symptom,
      severity: severity || 'LOW',
      logDate: logDate || log_date,
      notes
    };

    const newSymptom = await symptomModel.createSymptom(symptomData);
    
    res.status(201).json({
      success: true,
      message: 'Symptom logged successfully',
      data: newSymptom
    });
  } catch (error) {
    console.error('Error in addSymptom:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message
    });
  }
};

const getSymptom = async (req, res) => {
  try {
    const userId = req.user.id;
    const symptomId = req.params.id;

    const symptom = await symptomModel.getSymptomById(symptomId, userId);
    if (!symptom) {
      return res.status(404).json({
        success: false,
        message: 'Symptom log not found'
      });
    }
    
    res.status(200).json({
      success: true,
      message: 'Symptom retrieved successfully',
      data: symptom
    });
  } catch (error) {
    console.error('Error in getSymptom:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

const deleteSymptom = async (req, res) => {
  try {
    const userId = req.user.id;
    const symptomId = req.params.id;

    const existingSymptom = await symptomModel.getSymptomById(symptomId, userId);
    if (!existingSymptom) {
      return res.status(404).json({
        success: false,
        message: 'Symptom log not found'
      });
    }

    await symptomModel.deleteSymptom(symptomId, userId);
    
    res.status(200).json({
      success: true,
      message: 'Symptom log deleted successfully'
    });
  } catch (error) {
    console.error('Error in deleteSymptom:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

module.exports = {
  getSymptoms,
  addSymptom,
  getSymptom,
  deleteSymptom
};
