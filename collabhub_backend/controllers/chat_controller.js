const Conversation = require('../models/conversation_model');

exports.getmyConversations = async (req, res) => {
    try{
        const userId = req.user.id;
        const chats = await Conversation.find({
            members: userId
        }).populate('members', 'username email');

        res.status(200).json({chats});

    }
    catch(error){
        console.log(error);
        res.status(500).json({message: 'Server Error'});
    }
}