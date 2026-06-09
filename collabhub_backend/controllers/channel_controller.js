const Channel = require('../models/channel_model');

exports.createChannel = async (req, res) => {

    try {
        const {
            name,
            workspace,
        } = req.body;
        const userId = req.user.id;
        const channel = new Channel({
            name,
            workspace,
            createdby: userId,
            members: [userId],  
        });
        await channel.save();
        res.status(201).json({
            message: "Channel created",
            channel,
        });
    }
    catch (error) {
        res.status(500).json({
            error: error.message,
        });
    }
};

// exports.getworkspaceChannels = async (req, res) => {

//     try {
//         const workspaceId = req.params.workspaceId;
//         const channels = await Channel.find({ workspace: workspaceId })
//         .populate("createdby", "username")
//         .populate("members", "username");
//         res.status(200).json({
//             channels,
//         });
//     }
//     catch (error) {
//         res.status(500).json({
//             error: error.message,
//         });
//     }
// };


exports.getWorkspaceChannels = async (
    req,
    res
) => {
            
    try {

        const { workspaceId } = req.params;

        const channels = await Channel.find({

            workspace: workspaceId,
        });

        res.status(200).json({

            channels,
        });

    } catch(error) {

        res.status(500).json({
            error: error.message,
        });
    }
};
