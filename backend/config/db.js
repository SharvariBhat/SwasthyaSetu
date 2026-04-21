const mysql = require("mysql2");
require("dotenv").config();

const db = mysql.createPool({  // using createPool instead of createConnection to allow for multiple connections and better performance
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: process.env.DB_PORT,

  waitForConnections: true,  // allows the pool to create a queue of connection requests when all connections are in use
  connectionLimit: 10,  // limits the number of connections in the pool 
  queueLimit: 0  // no limit on the number of queued connection requests
});

// Test connection immediately
db.getConnection((err, connection) => {
  if (err) {
    console.error("Database connection failed:", err.message);
    return;
  }

  console.log("Database connected successfully");

  connection.release();  // releases the connection back to the pool so that it can be resued by other requests
});

module.exports = db;