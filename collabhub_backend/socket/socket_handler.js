const Message = require('../models/message_model');
const User = require('../models/user_model');

const socketHandler = (io) =>{
    io.on('connection', (socket) =>{
        console.log("User Connected");

        socket.on('joinChannel',(channelId) => {
            socket.join(channelId);
            console.log(`joined ${channelId}`);
        });

        socket.on('sendMessage', async(data) =>{
            try{
                const message = new Message({
                    text:data.text,
                    sender:data.sender,
                    channel:data.channel,

                });
                await message.save();

                const populatedMessage= await message.populate('sender','_id username');

                io.to(data.channel).emit('receiveMessage',populatedMessage);
            }
            catch(error)
            {
                console.log(error);
            }
        });

        socket.on('joinConversation',(conversationId) => {
            socket.join(conversationId);
            console.log(`joined conversation ${conversationId}`);
        });

        socket.on('sendDirectMessage', async(data) =>{
            io.to(data.conversationId).emit('receiveDirectMessage', data);
        });

        socket.on("userOnline",async(userId)=>{
            socket.userId=userId;
            await User.findByIdAndUpdate(
                userId,
                {
                    isOnline:true,
                }
            );
        }
        );
           
                

        socket.on('typing', (data) => {
            socket.to(data.channel).emit('typing', {username: data.username});
        });

        socket.on("disconnect", async () => {
        try {
            if (!socket.userId) return;
            await User.findByIdAndUpdate(
                socket.userId,
                {
                    isOnline: false,
                    lastSeen: new Date(),
                }
            );
            console.log(
                socket.userId +
                " went offline"
            );
        } 
        catch(error) {

            console.log(error);

        }

    });
    })
}

module.exports= socketHandler;