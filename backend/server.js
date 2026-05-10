require("dotenv").config();

const express = require("express");
const cors = require("cors");
const path = require("path");

const db = require("./config/db");

// Models
const userModel = require("./models/userModel");
const medicineModel = require("./models/medicineModel");
const medicalRecordModel = require("./models/medicalRecordModel");
const symptomModel = require("./models/symptomModel");
const reminderModel = require("./models/reminderModel");

// Routes
const authRoutes = require("./routes/authRoutes");
const medicineRoutes = require("./routes/medicineRoutes");
const medicalRecordRoutes = require("./routes/medicalRecordRoutes");
const symptomRoutes = require("./routes/symptomRoutes");
const reminderRoutes = require("./routes/reminderRoutes");
const userRoutes = require("./routes/userRoutes");

const app = express();

app.use(cors());
app.use(express.json());

// Serve uploaded files statically
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Initialize all database tables
userModel.initDb().catch(console.error);
medicineModel.initDb().catch(console.error);
medicalRecordModel.initDb().catch(console.error);
symptomModel.initDb().catch(console.error);
reminderModel.initDb().catch(console.error);

// Mount routes
app.use("/api/auth", authRoutes);
app.use("/api/medicines", medicineRoutes);
app.use("/api/medical-records", medicalRecordRoutes);
app.use("/api/symptoms", symptomRoutes);
app.use("/api/reminders", reminderRoutes);
app.use("/api/users", userRoutes);

// Add multer error handling middleware
const { handleMulterError } = require('./middleware/uploadMiddleware');
app.use(handleMulterError);

// Add error handling middleware
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(500).json({
    success: false,
    message: 'Internal server error',
    error: process.env.NODE_ENV === 'development' ? err.message : undefined
  });
});

// Health check
app.get("/", (req, res) => {
  res.send("SwasthyaSetu API is running");
});

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});