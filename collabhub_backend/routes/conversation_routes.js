const express = require('express');
const router = express.Router();
const Conversation = require('../models/conversation_model');

const { authMiddleware } = require('../middleware/auth_middleware');
const { getOrCreateConversation } = require('../controllers/conversation_controller');

router.post('/create', authMiddleware, getOrCreateConversation);

module.exports = router;