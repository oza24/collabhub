const User = require("../models/user_model");
const PasswordReset = require("../models/password_reset_model");
const transporter = require("../config/mail");
const bcrypt = require("bcrypt");
const WorkspaceInvitation = require("../models/workspace_invitation_model");
const Workspace = require("../models/workspace_model");
const jwt = require("jsonwebtoken");

exports.signup = async (req, res) => {

    try {

        const {
            username,
            email,
            password,
            role,
        } = req.body;

        const existingUser = await User.findOne({ email });

        if(existingUser) {

            return res.status(400).json({
                message: "User already exists",
            });
        }

        const hashedPassword = await bcrypt.hash(password, 10);

        const user = new User({

            username,
            email,

            password: hashedPassword,

            role,
        });

        await user.save();
        const invitations = await WorkspaceInvitation.find({
            email,
            status: "pending",
        });

        for(const invite of invitations){

            await Workspace.findByIdAndUpdate(
                invite.workspace,
                {
                    $push:{
                        members:user._id,
                    },
                }
            );

            await User.findByIdAndUpdate(
                user._id,
                {
                    $push:{
                        workspaces:
                        invite.workspace,
                    },
                }
            );

            invite.status = "accepted";

            await invite.save();
        }

        res.status(201).json({
            message: "Signup successful",
        });

    } catch(error) {

        res.status(500).json({
            error: error.message,
        });
    }
};

exports.login = async (req, res) => {

    try {
        console.log("Login Hit");
        console.log(req.body);

        const {
            email,
            password,
        } = req.body;

        const user = await User.findOne({ email });

        // if(!user) {

        //     return res.status(400).json({
        //         message: "User not found",
        //     });
        // }

        const isMatch = await bcrypt.compare(
            password,
            user.password,
        );

        // if(!isMatch) {

        //     return res.status(400).json({
        //         message: "Invalid password",
        //     });
        // }

        if(!user || !isMatch) {

            return res.status(400).json({
                message: "Invalid email or password",
            });
        }

        const token = jwt.sign(

            {
                id: user._id,
                role: user.role,
            },

            process.env.JWT_SECRET,

            {
                expiresIn: "7d",
            }
        );

        res.status(200).json({

            message: "Login successful",

            token,

            user: {

                id: user._id,
                username: user.username,
                email: user.email,
                role: user.role,
            },
        });

    } catch(error) {

        res.status(500).json({
            error: error.message,
        });
    }
};

exports.forgetPassword = async (req, res) => {
    try {
        const { email } = req.body;

        const user = await User.findOne({ email });

        if (!user) {
            return res.status(400).json({
                message: "User not found",
            });
        }
        
        const otp = Math.floor(100000 + Math.random() * 900000).toString();

        await PasswordReset.deleteMany({
            email,
        });

        await PasswordReset.create({
            email,
            otp,
            expiresAt: new Date(Date.now() + 15 * 60 * 1000),
        });

        await transporter.sendMail({

            from: process.env.EMAIL_USER,
            to: email,
            subject: "CollabHub Password Reset OTP",
            text: `Your OTP for password reset is: ${otp}. It is valid for 15 minutes.`,
        });

        res.status(200).json({
            message: "OTP sent to email",
        });
    } catch (error) {
        res.status(500).json({
            error: error.message,
        });
    }
};

exports.verifyOtp = async(req,res) =>{
    try{
        const { email, otp} = req.body;

        const record = await PasswordReset.findOne({
            email,
            otp,
        });

        if(!record)
        {
            return res.status(400).json({
                message: "Invalid Otp",
            });
        }

        if(record.expiresAt < new Date())
        {
            return res.status(400).json({
                message:"Otp expired",
            });
        }

        res.status(200).json({
            message:"Otp verified",
        });
        
    }
    catch(error)
    {
        res.status(500).json({
            error:error.message,
        });
    }
};

exports.resetPassword = async(req,res) =>{
    try{
        const{email,otp,password} = req.body;

        const record = await PasswordReset.findOne({
            email,otp,
        });

        if(!record)
        {
            return res.status(400).json({
                message:"Invalid Otp",
            });
        }

        if(record.expiresAt < new Date())
        {
            return res.status(400).json({
                message:"OTp Expired",
            });
        }

        const hashedPassword = await bcrypt.hash(password,10);

        await User.findOneAndUpdate(
            {email},
            {   
                password: hashedPassword,
            }
        );

        await PasswordReset.deleteMany({
            email,
        });

        res.status(200).json({
            message:"Password Reset Successfully",
        });
    }

    catch(error){
        res.status(500).json({
            error:error.message,
        });
    }
};




