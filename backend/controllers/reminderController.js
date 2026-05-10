const reminderModel = require('../models/reminderModel');

const getReminders = async (req, res) => {
  try {
    const userId = req.user.id;
    const reminders = await reminderModel.getRemindersByUserId(userId);
    
    res.status(200).json({
      success: true,
      message: 'Reminders retrieved successfully',
      data: reminders
    });
  } catch (error) {
    console.error('Error in getReminders:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

const addReminder = async (req, res) => {
  try {
    const userId = req.user.id;
    const {
      type,
      title,
      reminderTime, reminder_time,
      status,
      notes
    } = req.body;

    const finalReminderTime = reminderTime || reminder_time;

    // Basic validation
    if (!finalReminderTime) {
      return res.status(400).json({
        success: false,
        message: 'Reminder time is required'
      });
    }

    const reminderData = {
      userId,
      type: type || 'MEDICINE',
      title,
      reminderTime: finalReminderTime,
      status: status || 'ACTIVE',
      notes
    };

    const newReminder = await reminderModel.createReminder(reminderData);
    
    res.status(201).json({
      success: true,
      message: 'Reminder created successfully',
      data: newReminder
    });
  } catch (error) {
    console.error('Error in addReminder:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message
    });
  }
};

const getReminder = async (req, res) => {
  try {
    const userId = req.user.id;
    const reminderId = req.params.id;

    const reminder = await reminderModel.getReminderById(reminderId, userId);
    if (!reminder) {
      return res.status(404).json({
        success: false,
        message: 'Reminder not found'
      });
    }
    
    res.status(200).json({
      success: true,
      message: 'Reminder retrieved successfully',
      data: reminder
    });
  } catch (error) {
    console.error('Error in getReminder:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

const updateReminder = async (req, res) => {
  try {
    const userId = req.user.id;
    const reminderId = req.params.id;
    const {
      type,
      title,
      reminderTime, reminder_time,
      status,
      notes
    } = req.body;

    const finalReminderTime = reminderTime || reminder_time;

    // Check if reminder exists
    const existingReminder = await reminderModel.getReminderById(reminderId, userId);
    if (!existingReminder) {
      return res.status(404).json({
        success: false,
        message: 'Reminder not found'
      });
    }

    const updateData = {
      type,
      title,
      reminderTime: finalReminderTime,
      status,
      notes
    };

    const updatedReminder = await reminderModel.updateReminder(reminderId, userId, updateData);
    
    res.status(200).json({
      success: true,
      message: 'Reminder updated successfully',
      data: updatedReminder
    });
  } catch (error) {
    console.error('Error in updateReminder:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

const deleteReminder = async (req, res) => {
  try {
    const userId = req.user.id;
    const reminderId = req.params.id;

    const existingReminder = await reminderModel.getReminderById(reminderId, userId);
    if (!existingReminder) {
      return res.status(404).json({
        success: false,
        message: 'Reminder not found'
      });
    }

    await reminderModel.deleteReminder(reminderId, userId);
    
    res.status(200).json({
      success: true,
      message: 'Reminder deleted successfully'
    });
  } catch (error) {
    console.error('Error in deleteReminder:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

module.exports = {
  getReminders,
  addReminder,
  getReminder,
  updateReminder,
  deleteReminder
};
