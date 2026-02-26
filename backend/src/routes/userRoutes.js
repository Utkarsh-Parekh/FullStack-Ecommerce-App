const express = require('express');
const { register, login, currentUser, forgotPassword, verifyOtp, resetPassword, resendOTP, refreshToken, logout } = require('../controllers/userController');
const authMiddleware = require('../middleware/authMiddleware');
const router = express.Router();

router.post('/register', register);

router.post('/login', login);

router.get('/currentUser',authMiddleware, currentUser);

router.post('/forgot-password',forgotPassword);

router.post('/resend-Otp',resendOTP);

router.post('/verify-otp',verifyOtp);

router.post('/reset-otp',resetPassword);

router.post('/refresh-token',refreshToken);

router.post('/logOut',authMiddleware, logout);

module.exports = router;
