const db = require('../config/db');

const initDb = async () => {
    const queryText = `
    CREATE TABLE IF NOT EXISTS medicines (
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
    try {
        await db.query(queryText);
        console.log('Medicines table initialized successfully');
    } catch (error) {
        console.error('Error initializing medicines table:', error);
        throw error;
    }
};

const createMedicine = async (medicineData) => {
    const {
        userId,
        medicineName,
        dosage,
        timing,
        frequency,
        startDate,
        endDate,
        notes
    } = medicineData;

    const queryText = `
    INSERT INTO medicines (
      user_id, medicine_name, dosage, timing, frequency, 
      start_date, end_date, notes
    ) VALUES (
      $1, $2, $3, $4, $5, $6, $7, $8
    ) RETURNING id, user_id as "userId", medicine_name as "medicineName", 
                dosage, timing, frequency, start_date as "startDate", 
                end_date as "endDate", notes, is_active as "isActive",
                created_at as "createdAt", updated_at as "updatedAt";
  `;

    const values = [
        userId, medicineName, dosage, timing, frequency,
        startDate || new Date(), endDate, notes
    ];

    const result = await db.query(queryText, values);
    return result.rows[0];
};

const getMedicinesByUserId = async (userId) => {
    const queryText = `
    SELECT id, user_id as "userId", medicine_name as "medicineName", 
           dosage, timing, frequency, start_date as "startDate", 
           end_date as "endDate", notes, is_active as "isActive",
           created_at as "createdAt", updated_at as "updatedAt"
    FROM medicines 
    WHERE user_id = $1 AND is_active = TRUE
    ORDER BY created_at DESC;
  `;
    const result = await db.query(queryText, [userId]);
    return result.rows;
};

const getMedicineById = async (id, userId) => {
    const queryText = `
    SELECT id, user_id as "userId", medicine_name as "medicineName", 
           dosage, timing, frequency, start_date as "startDate", 
           end_date as "endDate", notes, is_active as "isActive",
           created_at as "createdAt", updated_at as "updatedAt"
    FROM medicines 
    WHERE id = $1 AND user_id = $2 AND is_active = TRUE;
  `;
    const result = await db.query(queryText, [id, userId]);
    return result.rows[0];
};

const updateMedicine = async (id, userId, updateData) => {
    const {
        medicineName,
        dosage,
        timing,
        frequency,
        startDate,
        endDate,
        notes
    } = updateData;

    const queryText = `
    UPDATE medicines 
    SET medicine_name = $3, dosage = $4, timing = $5, frequency = $6,
        start_date = $7, end_date = $8, notes = $9, updated_at = CURRENT_TIMESTAMP
    WHERE id = $1 AND user_id = $2 AND is_active = TRUE
    RETURNING id, user_id as "userId", medicine_name as "medicineName", 
              dosage, timing, frequency, start_date as "startDate", 
              end_date as "endDate", notes, is_active as "isActive",
              created_at as "createdAt", updated_at as "updatedAt";
  `;

    const values = [
        id, userId, medicineName, dosage, timing, frequency,
        startDate, endDate, notes
    ];

    const result = await db.query(queryText, values);
    return result.rows[0];
};

const deleteMedicine = async (id, userId) => {
    const queryText = `
    UPDATE medicines 
    SET is_active = FALSE, updated_at = CURRENT_TIMESTAMP
    WHERE id = $1 AND user_id = $2 AND is_active = TRUE
    RETURNING id;
  `;
    const result = await db.query(queryText, [id, userId]);
    return result.rows[0];
};

module.exports = {
    initDb,
    createMedicine,
    getMedicinesByUserId,
    getMedicineById,
    updateMedicine,
    deleteMedicine
};