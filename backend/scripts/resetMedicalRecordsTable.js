require('dotenv').config();
const db = require('../config/db');

const resetMedicalRecordsTable = async () => {
  try {
    console.log('Dropping medical_records table if exists...');
    await db.query('DROP TABLE IF EXISTS medical_records CASCADE;');
    
    console.log('Creating medical_records table...');
    const createTableQuery = `
      CREATE TABLE medical_records (
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
    
    await db.query(createTableQuery);
    
    console.log('Adding foreign key constraint...');
    await db.query(`
      ALTER TABLE medical_records 
      ADD CONSTRAINT medical_records_user_id_fkey 
      FOREIGN KEY (user_id) REFERENCES app_users(id) ON DELETE CASCADE;
    `);
    
    console.log('Medical records table reset successfully!');
    process.exit(0);
  } catch (error) {
    console.error('Error resetting medical_records table:', error);
    process.exit(1);
  }
};

resetMedicalRecordsTable();