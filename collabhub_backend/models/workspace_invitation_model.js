const mongoose = require("mongoose");

const invitationSchema = new mongoose.Schema({
    email: {
        type: String,
        required: true,
    },

    workspace: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Workspace",
    },

    invitedBy: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
    },

    status: {
        type: String,
        enum: ["pending", "accepted"],
        default: "pending",
    },
},
{
    timestamps: true,
});

module.exports = mongoose.model("WorkspaceInvitation",invitationSchema);