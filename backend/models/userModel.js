const db = require('../config/db');

const initDb = async () => {
  const queryText = `
    CREATE TABLE IF NOT EXISTS app_users (
      id SERIAL PRIMARY KEY,
      full_name VARCHAR(255) NOT NULL,
      email VARCHAR(255) UNIQUE NOT NULL,
      phone_number VARCHAR(20) UNIQUE NOT NULL,
      password_hash VARCHAR(255) NOT NULL,
      role VARCHAR(50) NOT NULL,
      aadhaar VARCHAR(20),
      gender VARCHAR(20),
      age INT,
      village VARCHAR(255),
      blood_group VARCHAR(10),
      has_chronic_disease BOOLEAN DEFAULT FALSE,
      chronic_disease_details TEXT,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
  `;
  try {
    await db.query(queryText);
    console.log('App Users table initialized successfully');
  } catch (error) {
    console.error('Error initializing app_users table:', error);
    throw error;
  }
};

const createUser = async (userData) => {
  const {
    fullName,
    email,
    phoneNumber,
    passwordHash,
    role,
    aadhaar,
    gender,
    age,
    village,
    bloodGroup,
    hasChronicDisease,
    chronicDiseaseDetails
  } = userData;

  const queryText = `
    INSERT INTO app_users (
      full_name, email, phone_number, password_hash, role, 
      aadhaar, gender, age, village, blood_group, 
      has_chronic_disease, chronic_disease_details
    ) VALUES (
      $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12
    ) RETURNING id, full_name as "fullName", email, phone_number as "phoneNumber", 
                role, aadhaar, gender, age, village, blood_group as "bloodGroup", 
                has_chronic_disease as "hasChronicDisease", 
                chronic_disease_details as "chronicDiseaseDetails",
                created_at as "createdAt", created_at as "updatedAt";
  `;
  
  const values = [
    fullName, email, phoneNumber, passwordHash, role,
    aadhaar, gender, age, village, bloodGroup,
    hasChronicDisease || false, chronicDiseaseDetails
  ];

  const result = await db.query(queryText, values);
  return result.rows[0];
};

const findByEmail = async (email) => {
  const queryText = `
    SELECT id, full_name as "fullName", email, phone_number as "phoneNumber", 
           password_hash as "passwordHash", role, aadhaar, gender, age, 
           village, blood_group as "bloodGroup", 
           has_chronic_disease as "hasChronicDisease", 
           chronic_disease_details as "chronicDiseaseDetails",
           created_at as "createdAt", created_at as "updatedAt"
    FROM app_users 
    WHERE email = $1;
  `;
  const result = await db.query(queryText, [email]);
  return result.rows[0];
};

module.exports = {
  initDb,
  createUser,
  findByEmail
};
