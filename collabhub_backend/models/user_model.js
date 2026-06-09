const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    username: {
        type: String,
        required: true,
    },
    email: {
        type: String,
        required: true,
        unique: true,
    },
    password: {
        type: String,
        required: true,
    },
    role:{
        type: String,
        enum: ['admin', 'user'],
        default: 'user',
    },
    workspaces:[
        {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'Workspace',
        }
    ],
    workspaceId:{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Workspace',
        default: null,
    },
    avatar:{
        type: String,
        default: " ",
    },
    bio:{
        type: String,
        default: " ",
    },
    isOnline:{
        type: Boolean,
        default: false,
    },
    lastSeen:{
        type: Date,
    },
});

module.exports = mongoose.model('User', userSchema);