const userModel = require('../models/userModel');

const getProfile = async (req, res) => {
  try {
    const userId = req.user.id;
    const user = await userModel.findById(userId);
    
    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found'
      });
    }

    res.status(200).json({
      success: true,
      message: 'Profile retrieved successfully',
      data: user
    });
  } catch (error) {
    console.error('Error in getProfile:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

const updateProfile = async (req, res) => {
  try {
    const userId = req.user.id;
    const {
      fullName, name,
      gender,
      age,
      village,
      bloodGroup, blood_group,
      allergies,
      chronicConditions, chronic_conditions,
      takingMedicineNow, taking_medicine_now
    } = req.body;

    const updateData = {
      fullName: fullName || name,
      gender,
      age,
      village,
      bloodGroup: bloodGroup || blood_group,
      allergies,
      chronicConditions: chronicConditions || chronic_conditions,
      takingMedicineNow: takingMedicineNow || taking_medicine_now
    };

    const updatedUser = await userModel.updateUser(userId, updateData);
    
    if (!updatedUser) {
      return res.status(404).json({
        success: false,
        message: 'User not found'
      });
    }

    res.status(200).json({
      success: true,
      message: 'Profile updated successfully',
      data: updatedUser
    });
  } catch (error) {
    console.error('Error in updateProfile:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

module.exports = {
  getProfile,
  updateProfile
};
