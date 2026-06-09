const express = require('express');
const router = express.Router();
const { sendMessage, getMessages } = require('../controllers/message_controller');
const { authMiddleware } = require('../middleware/auth_middleware');

router.post('/send', authMiddleware, sendMessage);
router.get('/:channelId', authMiddleware, getMessages);

module.exports = router;