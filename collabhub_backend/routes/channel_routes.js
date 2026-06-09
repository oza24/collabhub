const express = require('express');
const router = express.Router();

const { createChannel,getWorkspaceChannels } = require('../controllers/channel_controller');
const { authMiddleware } = require('../middleware/auth_middleware');

router.post('/create', authMiddleware, createChannel);
router.get('/:workspaceId', authMiddleware, getWorkspaceChannels);

module.exports = router;