const express = require('express');
const router = express.Router();

const { signup,login,forgetPassword,verifyOtp,resetPassword } = require("../controllers/auth_controller");

console.log("Auth routes loaded");

router.post('/signup',signup);
router.post('/login', login);
router.post('/forgot-password', forgetPassword);
router.post('/verify-otp', verifyOtp);
router.post('/reset-password', resetPassword);

module.exports = router;