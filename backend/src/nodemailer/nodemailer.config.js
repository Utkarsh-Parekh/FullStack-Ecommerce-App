const nodemailer = require("nodemailer");

// Create transporter ONCE
const transporter = nodemailer.createTransport({
  host: "smtp.gmail.com",
  port: 587,
  secure: false,
  auth: {
    user: process.env.EMAIL_ID,
    pass: process.env.NODEMAILER_PASSWORD,
  },
});

// Send OTP Email
const sendEmail = async (email, otp) => {
  await transporter.sendMail({
    from: `"Shopease" <${process.env.EMAIL_ID}>`,
    to: email,
    subject: "🔐 Reset Your Password - OTP Verification",
    html: `
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="UTF-8" />
      </head>
      <body style="margin:0; padding:0; background-color:#f4f6f8; font-family:Arial, sans-serif;">

        <table align="center" width="100%" cellpadding="0" cellspacing="0"
          style="max-width:600px; margin:40px auto; background:#ffffff; border-radius:12px;
          overflow:hidden; box-shadow:0 5px 20px rgba(0,0,0,0.1);">

          <!-- Header -->
          <tr>
            <td style="background:linear-gradient(135deg,#4f46e5,#7c3aed); padding:30px; text-align:center; color:#ffffff;">
              <h2 style="margin:0;">Password Reset Request</h2>
            </td>
          </tr>

          <!-- Body -->
          <tr>
            <td style="padding:40px; text-align:center;">
              <p style="font-size:16px; color:#555;">
                Hello,
              </p>

              <p style="font-size:16px; color:#555;">
                We received a request to reset your password.
              </p>

              <div style="margin:30px 0;">
                <span style="
                  display:inline-block;
                  padding:18px 35px;
                  font-size:30px;
                  letter-spacing:10px;
                  font-weight:bold;
                  color:#4f46e5;
                  background:#eef2ff;
                  border-radius:10px;
                ">
                  ${otp}
                </span>
              </div>

              <p style="font-size:14px; color:#888;">
                This OTP is valid for <strong>10 minutes</strong>.
              </p>

              <p style="font-size:14px; color:#888;">
                If you didn’t request this, please ignore this email.
              </p>
            </td>
          </tr>

          <!-- Footer -->
          <tr>
            <td style="background:#f9fafb; padding:20px; text-align:center; font-size:12px; color:#aaa;">
              © ${new Date().getFullYear()} Shopease. All rights reserved.
            </td>
          </tr>

        </table>
      </body>
      </html>
    `,
  });
};

module.exports = sendEmail;