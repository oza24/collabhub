const Workspace = require("../models/workspace_model");
const WorkspaceInvitation = require("../models/workspace_invitation_model");
const transporter = require("../config/mail");
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
            const workspace = await Workspace.findById(workspaceId);

            if(!workspace){
                return res.status(404).json({
                    message: "Workspace not found"
                });
            }

            const existingInvite = await WorkspaceInvitation.findOne({
                email,
                workspace: workspaceId,
                status: "pending",
            });

            if(existingInvite){
                return res.status(400).json({
                    message: "Invitation already sent"
                });
            }


            await WorkspaceInvitation.create({
                email,
                workspace: workspaceId,
                invitedBy: req.user.id,
            });

            await transporter.sendMail({

                from: process.env.EMAIL_USER,

                to: email,

                subject: "Workspace Invitation",

                html: `
                    <h2>You've been invited!</h2>

                    <p>
                    You have been invited to join
                    workspace:
                    <b>${workspace.name}</b>
                    </p>

                    <p>
                    Please register on CollabHub
                    using this email address.
                    </p>
                `,
            });

            return res.status(200).json({
                message:
                "Invitation email sent",
            });
        }

        const workspace = await Workspace.findById(workspaceId);

        const alreadyMember = workspace.members.some(
            member => member.toString() === user._id.toString()
        );

        if(alreadyMember){
            return res.status(400).json({
                message: "User already exists in workspace"
            });
        }

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