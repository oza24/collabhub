const express = require("express");
const router = express.Router();

const { getNotifications , unreadNotifications , markAsRead , markSingleNotificationRead } = require("../controllers/notification_controller");
const { authMiddleware } = require("../middleware/auth_middleware");


router.get("/", authMiddleware, getNotifications);
router.get("/unread", authMiddleware, unreadNotifications);
router.put("/mark-as-read", authMiddleware, markAsRead);
router.put("/:id/read",authMiddleware,markSingleNotificationRead);

module.exports = router;