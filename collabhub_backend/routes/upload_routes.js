const express =
require("express");

const router =
express.Router();

const upload =require("../middleware/upload_middleware");

const { uploadAvatar , uploadChatFile } =require("../controllers/upload_controller");

const { authMiddleware } =require("../middleware/auth_middleware");

router.post("/avatar",authMiddleware,upload.single("avatar"),uploadAvatar);
router.post("/chat-file",authMiddleware,upload.single("file"),uploadChatFile);

module.exports =router;