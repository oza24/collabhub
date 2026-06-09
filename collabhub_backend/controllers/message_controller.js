const Message = require('../models/message_model');

exports.sendMessage = async (req, res) => {
    try{
        const{ text , channel, } = req.body;
        const sender = req.user.id;
        const message = new Message({
            sender,
            channel,
            text,
        });
        await message.save();
        const populatedMessage = await message.populate("sender", "username");
        res.status(201).json({
            message: "Message sent",
            data: populatedMessage,
        });
    
    }
    catch(error){
        res.status(500).json({
            error: error.message,
        });
    }
};

exports.getMessages = async (req, res) => {
    try{
        const { channelId } = req.params;
        const messages = await Message.find({ channel: channelId })
        .populate("sender", "username")
        .sort({ timestamp: 1 });
        res.status(200).json({
            messages,
        });
    }
    catch(error){
        res.status(500).json({
            error: error.message,
        });
    }
};