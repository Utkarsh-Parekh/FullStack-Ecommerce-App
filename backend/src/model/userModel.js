const mongoose = require('mongoose');
const { authDB } = require('../config/dbConnection');

const userSchema = mongoose.Schema({
    username : {
        type:String,
        required: [true,"Please enter Username"]
    },

    emailId : {
        type:String,
        unique: true,
        required: [true,"Please enter emailID"]
    },

    password: {
        type: String,
        required: [true,"Please enter your password"]
    },

    phoneNumber: {
        type:String,
    },

    role:{
        type: String,
        enum: ["User","Admin"],
        default: "User"
    },

    isLoggedIn:{
        type: Boolean
    },

    refreshToken:{
        type:String
    }
});

const User = authDB.model('User', userSchema); 
module.exports = User;
