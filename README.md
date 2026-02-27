# 🛒 FullStack E-Commerce App — Authentication System

![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)
![Express.js](https://img.shields.io/badge/Express.js-000000?style=for-the-badge&logo=express&logoColor=white)
![MongoDB](https://img.shields.io/badge/MongoDB-47A248?style=for-the-badge&logo=mongodb&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Render](https://img.shields.io/badge/Deployed%20on-Render-46E3B7?style=for-the-badge&logo=render&logoColor=white)

A production-ready authentication system built with **Node.js**, **Express.js**, and **MongoDB**, deployed on **Render**, and fully integrated into a **Flutter** mobile application.

---

## 🚀 Live API

```
Base URL: https://fullstack-ecommerce-app-6vuy.onrender.com/api/v1/auth
```

## ✨ Features

### Backend
- ✅ User Registration with password hashing (bcrypt)
- ✅ User Login with JWT Access & Refresh Token
- ✅ Forgot Password via OTP on Email
- ✅ OTP Verification
- ✅ Resend OTP
- ✅ Reset Password
- ✅ Refresh Token (silent token renewal)
- ✅ Logout
- ✅ MongoDB dual database setup (Auth DB + Products DB)
- ✅ Deployed on Render

### Flutter App
- ✅ BLoC state management (Clean Architecture)
- ✅ Dio HTTP client with Auth Interceptor
- ✅ Silent token refresh (no user intervention)
- ✅ Auto logout on session expiry
- ✅ Secure token storage
- ✅ OTP input with Pinput
- ✅ GoRouter navigation
- ✅ Email validation
- ✅ Dark / Light theme support

---

## 🔗 API Endpoints

### Auth Routes — `/api/v1/auth/`

| Method | Endpoint | Auth Required | Description |
|--------|----------|:-------------:|-------------|
| `POST` | `/api/v1/auth/register` | ❌ | Register new user |
| `POST` | `/api/v1/auth/login` | ❌ | Login and get tokens |
| `GET`  | `/api/v1/auth/currentUser` | ✅ | Get logged in user info |
| `POST` | `/api/v1/auth/forgot-password` | ❌ | Send OTP to email |
| `POST` | `/api/v1/auth/verify-otp` | ❌ | Verify OTP code |
| `POST` | `/api/v1/auth/resend-Otp` | ❌ | Resend OTP to email |
| `POST` | `/api/v1/auth/reset-otp` | ❌ | Reset password |
| `POST` | `/api/v1/auth/refresh-token` | ❌ | Get new access token |
| `POST` | `/api/v1/auth/logOut` | ✅ | Logout user |

---

## 📝 API Reference

### Register
```http
POST /api/v1/auth/register
Content-Type: application/json

{
  "username": "Utkarsh Parekh",
  "emailId": "utkarsh@example.com",
  "password": "SecurePass@123"
}
```
**Response `201`**
```json
{
  "message": "User Registered SuccessFully",
  "user": {
    "id": "abc123",
    "username": "Utkarsh Parekh",
    "emailId": "utkarsh@example.com"
  }
}
```

---

### Login
```http
POST /api/v1/auth/login
Content-Type: application/json

{
  "emailId": "utkarsh@example.com",
  "password": "SecurePass@123"
}
```
**Response `200`**
```json
{
  "message": "User Logged in SuccessFully",
  "user": {
    "id": "abc123",
    "username": "Utkarsh Parekh",
    "emailId": "utkarsh@example.com",
    "isLoggedIn": true
  },
  "accessToken": "eyJhbGci...",
  "refreshToken": "eyJhbGci..."
}
```

---

### Current User
```http
GET /api/v1/auth/currentUser
Authorization: Bearer <accessToken>
```
**Response `200`**
```json
{
  "message": "Current User Information",
  "user": {
    "id": "abc123",
    "username": "Utkarsh Parekh",
    "emailId": "utkarsh@example.com",
    "isLoggedIn": true
  }
}
```

---

### Forgot Password
```http
POST /api/v1/auth/forgot-password
Content-Type: application/json

{
  "emailId": "utkarsh@example.com"
}
```
**Response `200`**
```json
{
  "message": "Otp Send Successfully"
}
```

---

### Verify OTP
```http
POST /api/v1/auth/verify-otp
Content-Type: application/json

{
  "email": "utkarsh@example.com",
  "otp": 123456
}
```
**Response `200`**
```json
{
  "message": "Otp Verified Successfully"
}
```

> OTP expires in **2 minutes**. Request a new one if expired.

---

### Resend OTP
```http
POST /api/v1/auth/resend-Otp
Content-Type: application/json

{
  "emailId": "utkarsh@example.com"
}
```
**Response `200`**
```json
{
  "message": "Otp Resend Successfully"
}
```

---

### Reset Password
```http
POST /api/v1/auth/reset-otp
Content-Type: application/json

{
  "email": "utkarsh@example.com",
  "password": "NewPass@123",
  "confirmPassword": "NewPass@123"
}
```
**Response `200`**
```json
{
  "message": "Password reset successfully"
}
```

---

### Refresh Token
```http
POST /api/v1/auth/refresh-token
Content-Type: application/json

{
  "refreshToken": "eyJhbGci..."
}
```
**Response `200`**
```json
{
  "accessToken": "eyJhbGci..."
}
```

---

### Logout
```http
POST /api/v1/auth/logOut
Authorization: Bearer <accessToken>
```
**Response `200`**
```json
{
  "message": "User logged out successfully"
}
```

---

## 🛠️ Tech Stack

### Backend
| Technology | Purpose |
|------------|---------|
| Node.js | Runtime environment |
| Express.js | Web framework |
| MongoDB Atlas | Cloud database |
| Mongoose | ODM for MongoDB |
| bcryptjs | Password hashing |
| JSON Web Token | Access & Refresh tokens |
| ResendOTP | email delivery (HTTPS-based)|
| dotenv | Environment variables |
| cors | Cross-origin requests |

### Flutter App
| Package | Purpose |
|---------|---------|
| flutter_bloc | State management |
| dio | HTTP client with interceptors |
| go_router | Navigation |
| pinput | OTP input UI |
| flutter_secure_storage | Secure token storage |
| flutter_dotenv | Environment variables |
| equatable | State comparison |

---

## ⚙️ Environment Variables

Create a `.env` file inside the `backend/` folder:

```env
PORT=3000
MONGODB_AUTH_URL=mongodb+srv://<username>:<password>@cluster.mongodb.net/Users?retryWrites=true&w=majority&appName=Ecommerce-API
MONGODB_PRODUCTS_URL=mongodb+srv://<username>:<password>@cluster.mongodb.net/Products?retryWrites=true&w=majority&appName=Ecommerce-API
JWT_SECRET=your_jwt_secret
JWT_REFRESH_SECRET=your_refresh_secret
EMAIL_USER=your_email@gmail.com
EMAIL_PASS=your_email_app_password
```

---

## 🏃 Running Locally

### Backend
```bash
# Clone the repo
git clone https://github.com/your-username/fullstack-ecommerce-app.git

# Navigate to backend
cd backend

# Install dependencies
npm install

# Start development server
npm run dev

# Server runs on http://localhost:3000
```

### Flutter App
```bash
# Navigate to frontend
cd frontend

# Install dependencies
flutter pub get

# Create .env file
echo "BASE_URL=http://10.0.2.2:3000/api/v1/auth/" > .env

# Run the app
flutter run
```

> **Note:** Use `10.0.2.2` instead of `localhost` when running on Android Emulator.

---

## ☁️ Deployment — Render

The backend is deployed on **Render** as a Web Service.

### Render Configuration
| Field | Value |
|-------|-------|
| Root Directory | `backend` |
| Build Command | `npm install` |
| Start Command | `node index.js` |
| Environment | `Node` |

---

## 🔐 Authentication Flow

```
User Opens App
      ↓
Check stored token
      ↓
Token exists? ──Yes──→ Go to Dashboard
      ↓ No
Login / Register
      ↓
Receive Access Token + Refresh Token
      ↓
Store securely on device
      ↓
Every API call → Attach Access Token
      ↓
Token expired? (401 response)
      ↓
Dio Interceptor silently calls /refresh-Token
      ↓
      ├── Success → Save new token → Retry original request ✅
      └── Failure → Clear tokens → Redirect to Login 🔒
```

---

## 📱 App Screens

| Screen | Description |
|--------|-------------|
| Login | Email & password login |
| Register | New user registration |
| Forgot Password | Enter email to receive OTP |
| OTP Verification | 6-digit OTP input with resend |
| Reset Password | Set new password after OTP verification |
| Dashboard | Protected home screen |

---

## 👨‍💻 Author

**Utkarsh Parekh**
