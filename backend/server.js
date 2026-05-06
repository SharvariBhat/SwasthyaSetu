require("dotenv").config();

const express = require("express");
const cors = require("cors");

const db = require("./config/db");
const userModel = require("./models/userModel");
const authRoutes = require("./routes/authRoutes");

const app = express();

app.use(cors());
app.use(express.json());

// Initialize database
userModel.initDb().catch(console.error);

// Mount routes
app.use("/api/auth", authRoutes);

// basic for now
app.get("/", (req, res) => {
  res.send("SwasthyaSetu API is running");
});

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});