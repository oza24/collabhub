const Notification = require("../models/notification_model");

exports.getNotifications = async (req, res) => {
    try {
        const notifications = await Notification.find({ receiver: req.user.id , isRead: false })
        .populate("sender", "username email")
        .sort({ createdAt: -1 });
        res.status(200).json({
            notifications,
        });
    }
    catch (error) {
        res.status(500).json({
            error: error.message,
        });
    }
};

exports.unreadNotifications = async (req, res) => {
    try {
        const count = await Notification.countDocuments({ receiver: req.user.id, isRead: false });
        res.status(200).json({
            count,
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
        await Notification.updateMany({ receiver: req.user.id, isRead: false },
            { isRead: true });

        res.status(200).json({
            message: "Notifications marked as read",
        });
    }
    catch (error) {
        res.status(500).json({
            error: error.message,
        });
    }
};


exports.markSingleNotificationRead =async (req,res)=>{
    try{
        await Notification.findByIdAndUpdate(
            req.params.id,
            {
                isRead:true,
            }
        );
        res.json({
            success:true,
        });

    }
    catch(error){
        res.status(500).json({
            error:error.message,
        });
    }

};