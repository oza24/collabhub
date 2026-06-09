const User = require("../models/user_model");

exports.getProfile = async (req, res) => {
  try {
    console.log("===============");
    console.log("GET PROFILE HIT");
    console.log("===============");

    console.log(req.user);

    const userId = req.user.id;

    console.log("User ID:", userId);

    const user = await User.findById(userId).select("-password");

    console.log("User Found:", user);

    res.json({ user });

  } catch (error) {
    console.log("PROFILE ERROR:");
    console.log(error);

    res.status(500).json({
      message: error.message,
    });
  }
};
       
exports.updateProfile = async (req, res) => {
    try {
        
        const { username, bio, avatar } = req.body;
        const userId = req.user.id;

        const updatedUser = await User.findByIdAndUpdate(
            userId,
            {
                username,
                bio,
                avatar,
            },
            { new: true }
        ).select("-password");
        res.json({
            updatedUser,
        });
    }
    catch (error) {
        res.status(500).json({
            message: error.message,
        });
    }
};