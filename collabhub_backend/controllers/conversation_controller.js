const Conversation = require('../models/conversation_model');

exports.getOrCreateConversation = async (req, res) => {

    try {
        
        const currentuser = req.user.id;
        const { receiverId } = req.body;

        let conversation = await Conversation.findOne({
            members: { $all: [currentuser, receiverId] },
        });

        if (!conversation) {
            conversation = new Conversation({
                members: [currentuser, receiverId],
            });
            await conversation.save();
        }
        res.status(200).json({
            conversation,
        });
    }
    catch (error) {
        res.status(500).json({
            error: error.message,
        });
    }
};