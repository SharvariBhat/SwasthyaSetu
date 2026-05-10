const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const userModel = require('../models/userModel');

const register = async (req, res) => {
  try {
    // Accept both frontend field names and existing backend names
    const {
      name, fullName,
      email,
      phone, phoneNumber,
      password,
      role,
      aadhaar,
      gender,
      age,
      village,
      bloodGroup, blood_group,
      hasChronicDisease, has_chronic_disease,
      chronicDiseaseDetails, chronic_disease_details,
      allergies,
      chronicConditions, chronic_conditions,
      takingMedicineNow, taking_medicine_now
    } = req.body;

    const finalName = name || fullName;
    const finalPhone = phone || phoneNumber;
    const finalBloodGroup = bloodGroup || blood_group;
    const finalHasChronic = hasChronicDisease || has_chronic_disease;
    const finalChronicDetails = chronicDiseaseDetails || chronic_disease_details;
    const finalChronicConditions = chronicConditions || chronic_conditions;
    const finalTakingMedicine = takingMedicineNow || taking_medicine_now;

    // Basic validation
    if (!finalName || !finalPhone || !password || !role) {
      return res.status(400).json({ message: 'Name, phone, password and role are required' });
    }

    // Check if user already exists by phone
    const existingUser = await userModel.findByPhone(finalPhone);
    if (existingUser) {
      return res.status(409).json({ message: 'User with this phone number already exists' });
    }

    // Check if email exists (if provided)
    if (email) {
      const existingEmail = await userModel.findByEmail(email);
      if (existingEmail) {
        return res.status(409).json({ message: 'User with this email already exists' });
      }
    }

    // Hash password
    const saltRounds = 10;
    const passwordHash = await bcrypt.hash(password, saltRounds);

    // Create user
    const newUser = await userModel.createUser({
      fullName: finalName,
      email: email || null,
      phoneNumber: finalPhone,
      passwordHash,
      role,
      aadhaar,
      gender,
      age,
      village,
      bloodGroup: finalBloodGroup,
      hasChronicDisease: finalHasChronic,
      chronicDiseaseDetails: finalChronicDetails,
      allergies,
      chronicConditions: finalChronicConditions,
      takingMedicineNow: finalTakingMedicine
    });

    // Generate JWT — use user_id from formatted response
    const token = jwt.sign(
      { id: newUser.user_id, phone: newUser.phone, role: newUser.role },
      process.env.JWT_SECRET || 'default_secret',
      { expiresIn: '24h' }
    );

    res.status(201).json({
      message: 'Registration successful',
      token,
      user: newUser
    });
  } catch (error) {
    console.error('Error in register:', error);
    // Duplicate key violation
    if (error.code === '23505') {
      return res.status(409).json({ message: 'A user with this phone number or email already exists' });
    }
    res.status(500).json({ message: 'Internal server error' });
  }
};

const login = async (req, res) => {
  try {
    // Accept phone-based login (frontend sends phone + password)
    const { phone, email, password } = req.body;

    if ((!phone && !email) || !password) {
      return res.status(400).json({ message: 'Phone/email and password are required' });
    }

    // Find user by phone or email
    let userRow;
    if (phone) {
      userRow = await userModel.findByPhone(phone);
    } else {
      userRow = await userModel.findByEmail(email);
    }

    if (!userRow) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    const isMatch = await bcrypt.compare(password, userRow.password_hash);
    if (!isMatch) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    // Format user for response (snake_case)
    const formattedUser = userModel.formatUser(userRow);

    // Generate JWT
    const token = jwt.sign(
      { id: userRow.id, phone: userRow.phone_number, role: userRow.role },
      process.env.JWT_SECRET || 'default_secret',
      { expiresIn: '24h' }
    );

    res.status(200).json({
      message: 'Login successful',
      token,
      user: formattedUser
    });
  } catch (error) {
    console.error('Error in login:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
};

module.exports = {
  register,
  login
};
