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

// Helper: format medicine row to snake_case matching Flutter MedicineModel
const formatMedicine = (row) => {
    if (!row) return null;
    return {
        member_medicine_id: row.id,
        medicine_id: row.id,
        medicine_name: row.medicine_name,
        dosage: row.dosage,
        timing: row.timing,
        frequency: row.frequency,
        start_date: row.start_date,
        end_date: row.end_date,
        notes: row.notes,
        is_active: row.is_active,
        created_at: row.created_at,
        updated_at: row.updated_at,
    };
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
    ) RETURNING *;
  `;

    const values = [
        userId, medicineName, dosage, timing, frequency,
        startDate || new Date(), endDate, notes
    ];

    const result = await db.query(queryText, values);
    return formatMedicine(result.rows[0]);
};

const getMedicinesByUserId = async (userId) => {
    const queryText = `
    SELECT * FROM medicines 
    WHERE user_id = $1 AND is_active = TRUE
    ORDER BY created_at DESC;
  `;
    const result = await db.query(queryText, [userId]);
    return result.rows.map(formatMedicine);
};

const getMedicineById = async (id, userId) => {
    const queryText = `
    SELECT * FROM medicines 
    WHERE id = $1 AND user_id = $2 AND is_active = TRUE;
  `;
    const result = await db.query(queryText, [id, userId]);
    return formatMedicine(result.rows[0]);
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
    RETURNING *;
  `;

    const values = [
        id, userId, medicineName, dosage, timing, frequency,
        startDate, endDate, notes
    ];

    const result = await db.query(queryText, values);
    return formatMedicine(result.rows[0]);
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