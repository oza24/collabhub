const DirectMessage = require("../models/direct_message_model");
const Conversation = require("../models/conversation_model");
const Notification = require("../models/notification_model");

exports.sendDirectMessage = async (req, res) => {
    try {
        const {
        conversationId,
        text,
        messageType,
        fileUrl,
        fileName,
        } = req.body;
        const sender = req.user.id;

        const message = new DirectMessage({
            conversation: conversationId,
            sender,
            text,
            messageType,
            fileUrl,
            fileName,
        });
        await message.save();

        const conversation =
        await Conversation.findById(conversationId);
        const receiverId =conversation.members.find(
            member =>member.toString() !==req.user.id
        );
        await Notification.create({
            receiver: receiverId,
            sender: req.user.id,
            type: "dm",
            message: "sent you a message",
            conversationId: conversationId,
        });


        await Conversation.findByIdAndUpdate(conversationId, {
            lastMessage: text,
            lastMessageTime: new Date(),
        });

        const populatedMessage = await message.populate("sender", "username email");
        res.status(201).json({
            message: "Direct message sent",
            data: populatedMessage,
        });
    }
    catch (error) {
        res.status(500).json({
            error: error.message,
        });
    }
};

exports.getDirectMessages = async (req, res) => {
    try {
        const { conversationId } = req.params;
        const messages = await DirectMessage.find({ conversation: conversationId })
        .populate("sender", "username email")
        .sort({ createdAt: 1 });
        res.status(200).json({
            messages,
        });
    }
    catch (error) {
        res.status(500).json({
            error: error.message,
        });
    }
};

exports.markAsRead = async (req, res) => {
    try {
        const { conversationId } = req.body;
        await DirectMessage.updateMany(
            { conversation: conversationId, sender: { $ne: req.user.id }, isRead: false },
            { isRead: true }
        );
        res.status(200).json({
            message: "Messages marked as read",
        });
    }
    catch (error) {
        res.status(500).json({
            error: error.message,
        });
    }
};
