const { Pool } = require("pg");
require("dotenv").config();  // enables us to use process.env which helps us in accessing .env variables  

const db = new Pool({  // using Pool instead of createConnection to allow for multiple connections and better performance
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: process.env.DB_PORT,

  ssl: {
    rejectUnauthorized: false  // this is necessary for connecting to some cloud databases that require SSL, but it should be used with caution in production environments
  },

  max: 10, // connection limit
});

db.connect()  // testing the connection to the database
  .then(() => {
    console.log("Database connected successfully");
  })
  .catch((err) => {
    console.error("Database connection failed:", err.message);
  });

module.exports = db;