const express = require('express');
const router = express.Router();
const { getmyConversations } = require('../controllers/chat_controller');
const { authMiddleware } = require('../middleware/auth_middleware');

router.get('/mychats', authMiddleware, getmyConversations);

module.exports = router;
