const Workspace = require("../models/workspace_model");
const Channel = require("../models/channel_model");
const Message = require("../models/message_model");
const Conversation = require("../models/conversation_model");
const User = require("../models/user_model");

exports.getDashboard = async (req, res) => {
    try {

        const userId = req.user.id;

        const user = await User.findById(userId).select("username");
        const username = user?.username || "User";

        // USER WORKSPACES
        const workspaces = await Workspace.find({
            members: userId,
        });

        const workspaceIds = workspaces.map(
            workspace => workspace._id
        );

        // ALL CHANNELS INSIDE USER WORKSPACES
        const channels = await Channel.find({
            workspace: {
                $in: workspaceIds,
            },
        });

        // UNIQUE MEMBER COUNT
        const uniqueMembers = new Set();

        workspaces.forEach((workspace) => {
            workspace.members.forEach((member) => {
                uniqueMembers.add(
                    member.toString()
                );
            });
        });

        const memberCount = uniqueMembers.size;

        // MESSAGE COUNT
        const channelIds = channels.map(
            channel => channel._id
        );

        const messageCount =
            await Message.countDocuments({
                channel: {
                    $in: channelIds,
                },
            });

        // RECENT WORKSPACES
        const recentWorkspaces =
            await Workspace.find({
                members: userId,
            })
            .populate(
                "members",
                "username email"
            )
            .select("name description  members")
            .sort({
                createdAt: -1,
            });

        const workspacesWithChannels =
            await Promise.all(
                recentWorkspaces.map(
                    async (workspace) => {

                        const channelCount =
                            await Channel.countDocuments({
                                workspace:
                                    workspace._id,
                            });

                        return {
                            ...workspace.toObject(),
                            channelCount,
                        };
                    }
                )
            );

        // RECENT CHATS
        const recentChats =
            await Conversation.find({
                members: userId,
            })
            .select(
                "members lastMessage lastMessageTime"
            )
            .populate(
                "members",
                "username email"
            )
            .sort({
                updatedAt: -1,
            })
            .limit(5);

            const validChats =
                recentChats.filter(
                    chat => chat.members.length >= 2
                );

        res.status(200).json({
            username,
            workspaceCount:
                workspaces.length,

            channelCount:
                channels.length,

            messageCount,

            memberCount,

            recentWorkspaces:
                workspacesWithChannels,

            recentChats : validChats,
        });

    } catch (error) {

        console.log(error);

        res.status(500).json({
            error: error.message,
        });
    }
};