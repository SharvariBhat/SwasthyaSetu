const db = require('../config/db');

const initDb = async () => {
  const queryText = `
    CREATE TABLE IF NOT EXISTS symptom_logs (
      id SERIAL PRIMARY KEY,
      user_id INTEGER NOT NULL,
      symptom TEXT NOT NULL,
      severity VARCHAR(20) NOT NULL DEFAULT 'LOW',
      log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      notes TEXT,
      is_active BOOLEAN DEFAULT TRUE,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
  `;
  try {
    await db.query(queryText);
    console.log('Symptom logs table initialized successfully');
  } catch (error) {
    console.error('Error initializing symptom_logs table:', error);
    throw error;
  }
};

// Helper: format row to snake_case matching Flutter SymptomModel
const formatSymptom = (row) => {
  if (!row) return null;
  return {
    log_id: row.id,
    symptom: row.symptom,
    severity: row.severity,
    log_date: row.log_date || row.created_at,
    notes: row.notes,
  };
};

const createSymptom = async (symptomData) => {
  const { userId, symptom, severity, logDate, notes } = symptomData;

  const queryText = `
    INSERT INTO symptom_logs (user_id, symptom, severity, log_date, notes)
    VALUES ($1, $2, $3, $4, $5)
    RETURNING *;
  `;

  const values = [userId, symptom, severity || 'LOW', logDate || new Date(), notes];
  const result = await db.query(queryText, values);
  return formatSymptom(result.rows[0]);
};

const getSymptomsByUserId = async (userId) => {
  const queryText = `
    SELECT * FROM symptom_logs 
    WHERE user_id = $1 AND is_active = TRUE
    ORDER BY log_date DESC, created_at DESC;
  `;
  const result = await db.query(queryText, [userId]);
  return result.rows.map(formatSymptom);
};

const getSymptomById = async (id, userId) => {
  const queryText = `
    SELECT * FROM symptom_logs 
    WHERE id = $1 AND user_id = $2 AND is_active = TRUE;
  `;
  const result = await db.query(queryText, [id, userId]);
  return formatSymptom(result.rows[0]);
};

const deleteSymptom = async (id, userId) => {
  const queryText = `
    UPDATE symptom_logs 
    SET is_active = FALSE
    WHERE id = $1 AND user_id = $2 AND is_active = TRUE
    RETURNING id;
  `;
  const result = await db.query(queryText, [id, userId]);
  return result.rows[0];
};

module.exports = {
  initDb,
  createSymptom,
  getSymptomsByUserId,
  getSymptomById,
  deleteSymptom
};
