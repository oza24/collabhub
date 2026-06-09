const express = require("express");

const router = express.Router();

const {createWorkspace,getWorkspaces,addMember} = require("../controllers/workspace_controller");

const {authMiddleware} = require("../middleware/auth_middleware");

router.post("/create",authMiddleware,createWorkspace);
router.post('/addmember',authMiddleware,addMember);
router.get('/getworkspaces',authMiddleware,getWorkspaces);
module.exports = router;