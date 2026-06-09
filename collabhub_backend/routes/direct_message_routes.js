const express = require('express');
const router = express.Router();

const { authMiddleware } = require('../middleware/auth_middleware');
const { sendDirectMessage, getDirectMessages , markAsRead } = require('../controllers/direct_message_controller');

router.post('/send', authMiddleware, sendDirectMessage);
router.get('/:conversationId', authMiddleware, getDirectMessages);
router.put('/read', authMiddleware, markAsRead);


module.exports = router;