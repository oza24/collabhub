const Workspace = require("../models/workspace_model");

const User = require("../models/user_model");
const { json } = require("express");

exports.createWorkspace = async (req, res) => {

    try {

        const {
            name,
            description,
        } = req.body;

        const userId = req.user.id;

        const workspace = new Workspace({

            name,
            description,

            owner: userId,

            members: [userId],
        });

        await workspace.save();

        await User.findByIdAndUpdate(
            userId,
            {
                $push: {
                    workspaces: workspace._id,
                },
            }
        );

        res.status(201).json({

            message: "Workspace created",

            workspace,
        });

    } catch(error) {

        res.status(500).json({
            error: error.message,
        });
    }
};

exports.getWorkspaces = async (req, res) => {

    try {

        const userId = req.user.id;

        const user = await User.findById(userId)
        .populate({
            path: "workspaces",
            populate: {
                path: "members",
                select:"username email"
            }
        })

        res.status(200).json({
            workspaces: user.workspaces,
        });

    } catch(error) {

        res.status(500).json({
            error: error.message,
        });
    }
};

exports.addMember= async(req,res)=>{
    try{
        const{workspaceId,email}=req.body;
        const user = await User.findOne({email});

        if(!user){
            return res.status(404).json({message:"Usr not Found"});
        }

        const workspace = await Workspace.findById(workspaceId);

        workspace.members.push(user._id);

        await User.findByIdAndUpdate(user._id,
            {
                $push: 
                {
                    workspaces:
                    workspace._id,
                },
            }
        );

        await workspace.save();

        res.status(200).json({
            message:"Member added"
        }); 
    }

    catch(error)
    {
        res.status(500).json({
            error: error.message
        });
    }
}