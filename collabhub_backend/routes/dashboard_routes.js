const express = require("express");

const router = express.Router();

const { getDashboard } = require("../controllers/dashboard_controller");

const { authMiddleware } = require("../middleware/auth_middleware");

router.get("/",authMiddleware,getDashboard);

module.exports = router;