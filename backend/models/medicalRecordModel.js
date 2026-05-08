const db = require('../config/db');

const initDb = async () => {
  const queryText = `
    CREATE TABLE IF NOT EXISTS medical_records (
      id SERIAL PRIMARY KEY,
      user_id INTEGER NOT NULL,
      record_type VARCHAR(100) NOT NULL,
      record_date DATE NOT NULL,
      diagnosis TEXT,
      doctor_name VARCHAR(255),
      hospital_name VARCHAR(255),
      file_path VARCHAR(500),
      file_name VARCHAR(255),
      file_size INTEGER,
      file_type VARCHAR(50),
      notes TEXT,
      is_active BOOLEAN DEFAULT TRUE,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
  `;
  try {
    await db.query(queryText);
    console.log('Medical records table initialized successfully');
  } catch (error) {
    console.error('Error initializing medical_records table:', error);
    throw error;
  }
};

const createMedicalRecord = async (recordData) => {
  const {
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
  } = recordData;

  const queryText = `
    INSERT INTO medical_records (
      user_id, record_type, record_date, diagnosis, doctor_name,
      hospital_name, file_path, file_name, file_size, file_type, notes
    ) VALUES (
      $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11
    ) RETURNING id, user_id as "userId", record_type as "recordType", 
                record_date as "recordDate", diagnosis, doctor_name as "doctorName",
                hospital_name as "hospitalName", file_path as "filePath", 
                file_name as "fileName", file_size as "fileSize", 
                file_type as "fileType", notes, is_active as "isActive",
                created_at as "createdAt", updated_at as "updatedAt";
  `;
  
  const values = [
    userId, recordType, recordDate, diagnosis, doctorName,
    hospitalName, filePath, fileName, fileSize, fileType, notes
  ];

  const result = await db.query(queryText, values);
  return result.rows[0];
};

const getMedicalRecordsByUserId = async (userId) => {
  const queryText = `
    SELECT id, user_id as "userId", record_type as "recordType", 
           record_date as "recordDate", diagnosis, doctor_name as "doctorName",
           hospital_name as "hospitalName", file_path as "filePath", 
           file_name as "fileName", file_size as "fileSize", 
           file_type as "fileType", notes, is_active as "isActive",
           created_at as "createdAt", updated_at as "updatedAt"
    FROM medical_records 
    WHERE user_id = $1 AND is_active = TRUE
    ORDER BY record_date DESC, created_at DESC;
  `;
  const result = await db.query(queryText, [userId]);
  return result.rows;
};

const getMedicalRecordById = async (id, userId) => {
  const queryText = `
    SELECT id, user_id as "userId", record_type as "recordType", 
           record_date as "recordDate", diagnosis, doctor_name as "doctorName",
           hospital_name as "hospitalName", file_path as "filePath", 
           file_name as "fileName", file_size as "fileSize", 
           file_type as "fileType", notes, is_active as "isActive",
           created_at as "createdAt", updated_at as "updatedAt"
    FROM medical_records 
    WHERE id = $1 AND user_id = $2 AND is_active = TRUE;
  `;
  const result = await db.query(queryText, [id, userId]);
  return result.rows[0];
};

const updateMedicalRecord = async (id, userId, updateData) => {
  const {
    recordType,
    recordDate,
    diagnosis,
    doctorName,
    hospitalName,
    notes
  } = updateData;

  const queryText = `
    UPDATE medical_records 
    SET record_type = $3, record_date = $4, diagnosis = $5, 
        doctor_name = $6, hospital_name = $7, notes = $8, 
        updated_at = CURRENT_TIMESTAMP
    WHERE id = $1 AND user_id = $2 AND is_active = TRUE
    RETURNING id, user_id as "userId", record_type as "recordType", 
              record_date as "recordDate", diagnosis, doctor_name as "doctorName",
              hospital_name as "hospitalName", file_path as "filePath", 
              file_name as "fileName", file_size as "fileSize", 
              file_type as "fileType", notes, is_active as "isActive",
              created_at as "createdAt", updated_at as "updatedAt";
  `;
  
  const values = [
    id, userId, recordType, recordDate, diagnosis, doctorName, hospitalName, notes
  ];

  const result = await db.query(queryText, values);
  return result.rows[0];
};

const deleteMedicalRecord = async (id, userId) => {
  const queryText = `
    UPDATE medical_records 
    SET is_active = FALSE, updated_at = CURRENT_TIMESTAMP
    WHERE id = $1 AND user_id = $2 AND is_active = TRUE
    RETURNING id, file_path as "filePath";
  `;
  const result = await db.query(queryText, [id, userId]);
  return result.rows[0];
};

module.exports = {
  initDb,
  createMedicalRecord,
  getMedicalRecordsByUserId,
  getMedicalRecordById,
  updateMedicalRecord,
  deleteMedicalRecord
};