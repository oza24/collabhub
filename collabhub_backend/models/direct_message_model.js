const mongoose = require('mongoose');

const directMessageSchema = new mongoose.Schema({
    conversation: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Conversation',
    },
    sender: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
    },
    text: {
        type: String,
    },
    messageType: {
        type: String,
        enum: ["text", "image", "file"],
        default: "text",
    },

    fileUrl: {
        type: String,
        default: "",
    },

    fileName: {
        type: String,
        default: "",
    },
    timestamp: {
        type: Date,
        default: Date.now,
    },
    isRead: {
        type: Boolean,
        default: false,
    },
});

module.exports = mongoose.model('DirectMessage', directMessageSchema);