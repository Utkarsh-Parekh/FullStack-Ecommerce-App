const User = require('../model/userModel');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const crypto = require('crypto');
const Otp = require('../model/otpModel');
const sendEmail = require('../nodemailer/nodemailer.config');

const register = async (req, res) => {
    try {
        const { username, emailId, password } = req.body;

        if (!username || !emailId || !password) {
            return res.status(400).json({
                message: "All Fields are Required"
            })
        }

        const userAvailable = await User.findOne({ emailId });

        if (userAvailable) {
            return res.status(400).json({
                message: "User is already registered"
            })
        }
        const hashedPassword = await bcrypt.hash(password, 10);

        const newUser = new User({
            username: username,
            emailId: emailId,
            password: hashedPassword
        });

        await newUser.save();

        res.status(201).json({
            message: "User Registered SuccessFully",
            user: {
                id: newUser._id,
                username: newUser.username,
                emailId: newUser.emailId,
                password: newUser.password
            }
        })
    }
    catch (err) {
        console.error("Register Error:", err);

        res.status(500).json({
            message: "Error while Register the user"
        })
    }
}

const login = async (req, res) => {
    try {

        const { emailId, password } = req.body;

        if (!emailId || !password) {
            return res.status(400).json({
                message: "All Fields are Required"
            })
        }

        const user = await User.findOne({ emailId });

        if (!user) {
            return res.status(400).json({
                message: "User Not Found"
            })
        }

        const comparedPassword = await bcrypt.compare(password, user.password);

        if (!comparedPassword) {
            return res.status(400).json({
                message: "Invalid Password"
            })
        }

        const accessToken = jwt.sign({
            user: {
                username: user.username,
                emailId: user.emailId,
                id: user.id
            },

        },
            process.env.JWT_ACCESS_SECRET,
            { expiresIn: "15m" }

        );

        const refreshToken = jwt.sign({
            id: user.id,
        },
            process.env.JWT_REFRESH_SECRET,
            { expiresIn: '7d' });

        user.refreshToken = crypto.createHash('sha256').update(refreshToken).digest('hex');
        user.isLoggedIn = true;
        await user.save();

        res.status(200).json({
            message: "User Logged in SuccessFully",
            user: {
                "id": user._id,
                "username": user.username,
                "emailId": user.emailId,
                 "isLoggedIn": user.isLoggedIn
            },
            accessToken,
            refreshToken
        })

    } catch (error) {
        res.status(500).json({
            message: "Server Error"
        })
    }
}


const currentUser = async (req, res) => {
    try {
        const user = await User.findById(req.user.id);

        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }

        res.status(200).json({
            message: "Current User Information",
            user: {
                id: user._id,
                username: user.username,
                emailId: user.emailId,
                isLoggedIn: user.isLoggedIn,
            }
        });
    } catch (error) {
        res.status(500).json({ message: "Server Error" });
    }
}

const forgotPassword = async (req, res) => {
    try {
        const { emailId } = req.body;

        const isUserAvailable = await User.findOne({ emailId: emailId });

        if (!isUserAvailable) {
            return res.status(404).json({
                message: "User doesn't exists"
            });
        }

        const otp = Math.floor(100000 + Math.random() * 900000);
        console.log(`otp is ${otp}`);

        const newOtp = new Otp({
            email: emailId,
            otp
        });

        await newOtp.save();

        await sendEmail(emailId, otp);

        res.status(200).json({
            message: "Otp send Successfully"
        });

    } catch (error) {
        res.status(500).json({
            message: "Server Error"
        })
    }
}

const resendOTP = async (req, res) => {
    try {
        const { emailId } = req.body;

        const isUserAvailable = await User.findOne({ emailId: emailId });

        if (!isUserAvailable) {
            return res.status(404).json({
                message: "User doesn't exists"
            });
        }


        const otp = Math.floor(100000 + Math.random() * 900000);
        console.log(`otp is ${otp}`);

        const newOtp = new Otp({
            email: emailId,
            otp
        });

        await newOtp.save();

        await sendEmail(emailId, otp);

        res.status(200).json({
            message: "Otp Resend Successfully"
        });

    } catch (error) {
        res.status(500).json({
            message: "Server Error"
        })
    }
}

const verifyOtp = async (req, res) => {
    try {
        const { email, otp } = req.body;

        const recordedOtp = await Otp.findOne({ email, otp: Number(otp) });

        if (!recordedOtp) {
            return res.status(400).json({
                message: "Otp expired or Invalid"
            })
        }

        const now = new Date().getTime();
        const otpCreatedTime = new Date(recordedOtp.createdAt).getTime();
        if (now > otpCreatedTime + 2 * 60 * 1000) {
            return res.status(400).json({
                message: "OTP expired. Please request a new one."
            });
        }

        await Otp.deleteOne({ _id: recordedOtp._id });

        res.status(200).json({
            message: "Otp Verified Successfully"
        });


    } catch (error) {
        res.status(500).json({
            message: "Server Error"
        });
    }
}

const resetPassword = async (req, res) => {
    try {
        const { email, password, confirmPassword } = req.body;

        if (!email || !password || !confirmPassword) {
            return res.status(400).json({ message: "All fields are required" });
        }

        if (password !== confirmPassword) {
            return res.status(400).json({ message: "Passwords do not match" });
        }

        const user = await User.findOne({ emailId: email });

        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }

        const hashedPassword = await bcrypt.hash(confirmPassword, 10);

        user.password = hashedPassword;
        await user.save();


        res.status(200).json({ message: "Password reset successfully" });
    } catch (error) {
        res.status(500).json({ message: "Server Error" });

    }


}

const refreshToken = async (req, res) => {
    try {
        const { refreshToken } = req.body;
        if (!refreshToken)
            return res.status(401).json({ message: "Refresh token required" });

        const decoded = jwt.verify(
            refreshToken,
            process.env.JWT_REFRESH_SECRET
        );


        const hashedToken = crypto
            .createHash("sha256")
            .update(refreshToken)
            .digest("hex");

        const user = await User.findById(decoded.id);

        if (!user || user.refreshToken !== hashedToken) {
            return res.status(403).json({ message: "Invalid refresh token" });
        }

        const newAccessToken = jwt.sign(
            {
                user: {
                    username: user.username,
                    emailId: user.emailId,
                    id: user.id
                },
            },
            process.env.JWT_ACCESS_SECRET,
            { expiresIn: "15m" }
        );

        res.status(200).json({ accessToken: newAccessToken });

    } catch (err) {
        return res.status(403).json({ message: "Invalid or expired refresh token" });
    }
};


const logout = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // Set flag to false and remove refresh token
    user.isLoggedIn = false;
    user.refreshToken = null;
    await user.save();

    res.status(200).json({ message: "User logged out successfully" });
  } catch (error) {
    res.status(500).json({ message: "Server Error" });
  }
};


module.exports = { register, login, currentUser, forgotPassword, verifyOtp, resetPassword, resendOTP,refreshToken,logout };