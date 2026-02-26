const mongoose = require("mongoose");

const { authDB } = require('../config/dbConnection');

const OtpSchema = new mongoose.Schema({

    otp: {
        type: Number,
        required: true
    },

    "email": {
        type: String,
        required: true
    },

    createdAt: {
        type: Date,
        required: true,
        default: Date.now,
        expires: "2m"
    }

});

const Otps = authDB.model('OTP', OtpSchema); 
module.exports = Otps;
