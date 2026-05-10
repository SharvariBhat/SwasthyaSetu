const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const authMiddleware = require('../middleware/authMiddleware');

// All user routes require authentication
router.use(authMiddleware);

// GET /api/users/profile - Get authenticated user's profile
router.get('/profile', userController.getProfile);

// PUT /api/users/profile - Update authenticated user's profile
router.put('/profile', userController.updateProfile);

module.exports = router;
