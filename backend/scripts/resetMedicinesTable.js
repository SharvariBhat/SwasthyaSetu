require('dotenv').config();
const db = require('../config/db');

const resetMedicinesTable = async () => {
  try {
    console.log('Dropping medicines table if exists...');
    await db.query('DROP TABLE IF EXISTS medicines CASCADE;');
    
    console.log('Creating medicines table...');
    const createTableQuery = `
      CREATE TABLE medicines (
        id SERIAL PRIMARY KEY,
        user_id INTEGER NOT NULL,
        medicine_name VARCHAR(255) NOT NULL,
        dosage VARCHAR(100) NOT NULL,
        timing VARCHAR(50) NOT NULL,
        frequency VARCHAR(50) NOT NULL,
        start_date DATE DEFAULT CURRENT_DATE,
        end_date DATE,
        notes TEXT,
        is_active BOOLEAN DEFAULT TRUE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `;
    
    await db.query(createTableQuery);
    
    console.log('Adding foreign key constraint...');
    await db.query(`
      ALTER TABLE medicines 
      ADD CONSTRAINT medicines_user_id_fkey 
      FOREIGN KEY (user_id) REFERENCES app_users(id) ON DELETE CASCADE;
    `);
    
    console.log('Medicines table reset successfully!');
    process.exit(0);
  } catch (error) {
    console.error('Error resetting medicines table:', error);
    process.exit(1);
  }
};

resetMedicinesTable();