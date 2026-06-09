const express = require("express");

const router = express.Router();

const { authMiddleware } =require("../middleware/auth_middleware");

const { getProfile, updateProfile } =require("../controllers/profile_controller");

router.get("/",authMiddleware,getProfile);

router.put("/",authMiddleware,updateProfile);

module.exports = router;