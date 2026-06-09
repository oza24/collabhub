const User =require("../models/user_model");

exports.getUserStatus =async (req, res) => {
        try {
            const user =
                await User.findById(
                    req.params.id
                );
            res.json({
                isOnline:
                    user.isOnline,
                lastSeen:
                    user.lastSeen,
            });
        }
        catch (error) {
            res.status(500).json({
                message:
                    error.message,
            });
        }
    };