const db = require('../config/db');

const initDb = async () => {
  const queryText = `
    CREATE TABLE IF NOT EXISTS reminders (
      id SERIAL PRIMARY KEY,
      user_id INTEGER NOT NULL,
      type VARCHAR(50) NOT NULL DEFAULT 'MEDICINE',
      title VARCHAR(255),
      reminder_time VARCHAR(50) NOT NULL,
      status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
      notes TEXT,
      is_active BOOLEAN DEFAULT TRUE,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
  `;
  try {
    await db.query(queryText);
    console.log('Reminders table initialized successfully');
  } catch (error) {
    console.error('Error initializing reminders table:', error);
    throw error;
  }
};

// Helper: format row to snake_case matching Flutter ReminderModel
const formatReminder = (row) => {
  if (!row) return null;
  return {
    reminder_id: row.id,
    type: row.type,
    title: row.title,
    reminder_time: row.reminder_time,
    status: row.status,
    notes: row.notes,
    created_at: row.created_at,
    updated_at: row.updated_at,
  };
};

const createReminder = async (reminderData) => {
  const { userId, type, title, reminderTime, status, notes } = reminderData;

  const queryText = `
    INSERT INTO reminders (user_id, type, title, reminder_time, status, notes)
    VALUES ($1, $2, $3, $4, $5, $6)
    RETURNING *;
  `;

  const values = [
    userId,
    type || 'MEDICINE',
    title,
    reminderTime,
    status || 'ACTIVE',
    notes
  ];

  const result = await db.query(queryText, values);
  return formatReminder(result.rows[0]);
};

const getRemindersByUserId = async (userId) => {
  const queryText = `
    SELECT * FROM reminders 
    WHERE user_id = $1 AND is_active = TRUE
    ORDER BY created_at DESC;
  `;
  const result = await db.query(queryText, [userId]);
  return result.rows.map(formatReminder);
};

const getReminderById = async (id, userId) => {
  const queryText = `
    SELECT * FROM reminders 
    WHERE id = $1 AND user_id = $2 AND is_active = TRUE;
  `;
  const result = await db.query(queryText, [id, userId]);
  return formatReminder(result.rows[0]);
};

const updateReminder = async (id, userId, updateData) => {
  const { type, title, reminderTime, status, notes } = updateData;

  const queryText = `
    UPDATE reminders 
    SET type = COALESCE($3, type),
        title = COALESCE($4, title),
        reminder_time = COALESCE($5, reminder_time),
        status = COALESCE($6, status),
        notes = COALESCE($7, notes),
        updated_at = CURRENT_TIMESTAMP
    WHERE id = $1 AND user_id = $2 AND is_active = TRUE
    RETURNING *;
  `;

  const values = [id, userId, type, title, reminderTime, status, notes];
  const result = await db.query(queryText, values);
  return formatReminder(result.rows[0]);
};

const deleteReminder = async (id, userId) => {
  const queryText = `
    UPDATE reminders 
    SET is_active = FALSE, updated_at = CURRENT_TIMESTAMP
    WHERE id = $1 AND user_id = $2 AND is_active = TRUE
    RETURNING id;
  `;
  const result = await db.query(queryText, [id, userId]);
  return result.rows[0];
};

module.exports = {
  initDb,
  createReminder,
  getRemindersByUserId,
  getReminderById,
  updateReminder,
  deleteReminder
};
