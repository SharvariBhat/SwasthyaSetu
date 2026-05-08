require("dotenv").config();

const express = require("express");
const cors = require("cors");

const db = require("./config/db");
const userModel = require("./models/userModel");
const medicineModel = require("./models/medicineModel");
const medicalRecordModel = require("./models/medicalRecordModel");
const authRoutes = require("./routes/authRoutes");
const medicineRoutes = require("./routes/medicineRoutes");
const medicalRecordRoutes = require("./routes/medicalRecordRoutes");

const app = express();

app.use(cors());
app.use(express.json());

// Initialize database
userModel.initDb().catch(console.error);
medicineModel.initDb().catch(console.error);
medicalRecordModel.initDb().catch(console.error);

// Add error handling middleware
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(500).json({
    success: false,
    message: 'Internal server error',
    error: process.env.NODE_ENV === 'development' ? err.message : undefined
  });
});

// Mount routes
app.use("/api/auth", authRoutes);
app.use("/api/medicines", medicineRoutes);
app.use("/api/medical-records", medicalRecordRoutes);

// Add multer error handling middleware
const { handleMulterError } = require('./middleware/uploadMiddleware');
app.use(handleMulterError);

// basic for now
app.get("/", (req, res) => {
  res.send("SwasthyaSetu API is running");
});

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});