const db = require('../config/db');

const initDb = async () => {
  const queryText = `
    CREATE TABLE IF NOT EXISTS app_users (
      id SERIAL PRIMARY KEY,
      full_name VARCHAR(255) NOT NULL,
      email VARCHAR(255) UNIQUE,
      phone_number VARCHAR(20) UNIQUE NOT NULL,
      password_hash VARCHAR(255) NOT NULL,
      role VARCHAR(50) NOT NULL,
      aadhaar VARCHAR(20),
      gender VARCHAR(20),
      age INT,
      village VARCHAR(255),
      blood_group VARCHAR(10),
      allergies TEXT,
      chronic_conditions TEXT,
      taking_medicine_now VARCHAR(5) DEFAULT 'NO',
      has_chronic_disease BOOLEAN DEFAULT FALSE,
      chronic_disease_details TEXT,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
  `;

  // Add new columns if they don't exist (for existing tables)
  const alterQueries = [
    `ALTER TABLE app_users ADD COLUMN IF NOT EXISTS allergies TEXT;`,
    `ALTER TABLE app_users ADD COLUMN IF NOT EXISTS chronic_conditions TEXT;`,
    `ALTER TABLE app_users ADD COLUMN IF NOT EXISTS taking_medicine_now VARCHAR(5) DEFAULT 'NO';`,
  ];

  try {
    await db.query(queryText);
    for (const q of alterQueries) {
      try { await db.query(q); } catch (e) { /* column may already exist */ }
    }
    console.log('App Users table initialized successfully');
  } catch (error) {
    console.error('Error initializing app_users table:', error);
    throw error;
  }
};

// Helper: format user row to snake_case matching Flutter model
const formatUser = (row) => {
  if (!row) return null;
  return {
    user_id: row.id,
    name: row.full_name,
    phone: row.phone_number,
    role: row.role,
    email: row.email,
    aadhaar_num: row.aadhaar,
    gender: row.gender,
    age: row.age,
    village: row.village,
    blood_group: row.blood_group,
    allergies: row.allergies,
    chronic_conditions: row.chronic_conditions,
    taking_medicine_now: row.taking_medicine_now || 'NO',
    created_at: row.created_at,
  };
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
    chronicDiseaseDetails,
    allergies,
    chronicConditions,
    takingMedicineNow
  } = userData;

  const queryText = `
    INSERT INTO app_users (
      full_name, email, phone_number, password_hash, role, 
      aadhaar, gender, age, village, blood_group, 
      has_chronic_disease, chronic_disease_details,
      allergies, chronic_conditions, taking_medicine_now
    ) VALUES (
      $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15
    ) RETURNING *;
  `;
  
  const values = [
    fullName, email, phoneNumber, passwordHash, role,
    aadhaar, gender, age, village, bloodGroup,
    hasChronicDisease || false, chronicDiseaseDetails,
    allergies || null, chronicConditions || null, takingMedicineNow || 'NO'
  ];

  const result = await db.query(queryText, values);
  return formatUser(result.rows[0]);
};

const findByEmail = async (email) => {
  const queryText = `SELECT * FROM app_users WHERE email = $1;`;
  const result = await db.query(queryText, [email]);
  return result.rows[0]; // Return raw row (need passwordHash for auth)
};

const findByPhone = async (phone) => {
  const queryText = `SELECT * FROM app_users WHERE phone_number = $1;`;
  const result = await db.query(queryText, [phone]);
  return result.rows[0]; // Return raw row (need password_hash for auth)
};

const findById = async (id) => {
  const queryText = `SELECT * FROM app_users WHERE id = $1;`;
  const result = await db.query(queryText, [id]);
  return formatUser(result.rows[0]);
};

const updateUser = async (id, updateData) => {
  const {
    fullName,
    gender,
    age,
    village,
    bloodGroup,
    allergies,
    chronicConditions,
    takingMedicineNow
  } = updateData;

  const queryText = `
    UPDATE app_users 
    SET full_name = COALESCE($2, full_name),
        gender = COALESCE($3, gender),
        age = COALESCE($4, age),
        village = COALESCE($5, village),
        blood_group = COALESCE($6, blood_group),
        allergies = COALESCE($7, allergies),
        chronic_conditions = COALESCE($8, chronic_conditions),
        taking_medicine_now = COALESCE($9, taking_medicine_now)
    WHERE id = $1
    RETURNING *;
  `;

  const values = [
    id, fullName, gender, age, village, bloodGroup,
    allergies, chronicConditions, takingMedicineNow
  ];

  const result = await db.query(queryText, values);
  return formatUser(result.rows[0]);
};

module.exports = {
  initDb,
  createUser,
  findByEmail,
  findByPhone,
  findById,
  updateUser,
  formatUser
};
