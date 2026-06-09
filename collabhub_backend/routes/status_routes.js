const express =require("express");

const router =express.Router();

const { authMiddleware } =require("../middleware/auth_middleware");

const { getUserStatus } =require("../controllers/status_controller");

router.get("/:id",authMiddleware,getUserStatus);

module.exports =router;