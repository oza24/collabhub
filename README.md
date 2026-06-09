# 🚀 CollabHub

CollabHub is a full-stack real-time collaboration platform inspired by Slack and Discord. It enables teams to communicate through workspaces, channels, and direct messaging while providing real-time communication, notifications, file sharing, and user presence tracking.

Built using **Flutter**, **Node.js**, **MongoDB**, and **Socket.IO**.

---

# ✨ Features

## 🔐 Authentication

* User Registration
* User Login
* JWT Authentication
* Secure Password Hashing (bcrypt)
* Forgot Password with OTP Verification
* Password Reset via Email

## 🏢 Workspaces

* Create Workspaces
* View Workspace Details
* Join and Collaborate with Team Members
* Workspace Dashboard

## 📢 Channels

* Create Channels
* Channel-based Communication
* Real-time Group Messaging

## 💬 Direct Messaging

* One-to-One Conversations
* Real-time Messaging using Socket.IO
* Chat History Persistence
* Read Receipts
* Online/Offline Status
* Last Seen Tracking

## 📁 File Sharing

* Upload Files in Direct Messages
* Image Sharing Support
* Cloudinary Integration
* Open Shared Files Directly

## 🔔 Notifications

* Real-time Notifications
* Unread Notification Count
* Mark Notifications as Read

## 📊 Dashboard

* Workspace Statistics
* Channel Statistics
* Member Statistics
* Recent Workspaces
* Recent Chats

## 🔍 Search

* Workspace Search Functionality

---

# 🛠️ Tech Stack

### Frontend

* Flutter
* Dart
* Go Router
* Dio
* Socket.IO Client
* File Picker

### Backend

* Node.js
* Express.js
* Socket.IO
* JWT
* bcrypt

### Database

* MongoDB
* Mongoose

### Cloud Services

* Cloudinary
* Gmail SMTP

---

# 📂 Project Structure

```text
CollabHub
│
├── collabhub_frontend
│
└── collabhub_backend
```

---

# ⚙️ Backend Setup

Navigate to backend:

```bash
cd collabhub_backend
```

Install dependencies:

```bash
npm install
```

Create a `.env` file:

```env
PORT=3000

MongodbUri=YOUR_MONGODB_URI

JWT_SECRET=YOUR_SECRET_KEY

EMAIL_USER=YOUR_EMAIL

EMAIL_PASS=YOUR_APP_PASSWORD

CLOUDINARY_CLOUD_NAME=YOUR_CLOUD_NAME

CLOUDINARY_API_KEY=YOUR_API_KEY

CLOUDINARY_API_SECRET=YOUR_API_SECRET
```

Start server:

```bash
npm run dev
```

---

# ⚙️ Frontend Setup

Navigate to frontend:

```bash
cd collabhub_frontend
```

Install dependencies:

```bash
flutter pub get
```

Update API URL:

```dart
class ApiConstants {
  static const String baseUrl =
      "http://YOUR_LOCAL_IP:3000/api/";
}
```

Run the application:

```bash
flutter run
```

---

# 🔄 Real-Time Features

* Real-time Channel Messaging
* Real-time Direct Messaging
* Typing Indicators
* Online/Offline Presence
* Last Seen Tracking
* Instant Notifications
* Read Receipts

---

# 🔒 Security

* JWT Authentication
* Protected API Routes
* Password Hashing using bcrypt
* OTP Verification for Password Recovery

---

# ✅ Completed Features

* Authentication System
* Forgot Password with OTP
* Workspace Management
* Channel Management
* Real-time Group Chat
* Direct Messaging
* Notifications
* File Sharing
* Read Receipts
* Online/Offline Status
* Last Seen Tracking
* Dashboard Analytics
* Workspace Search

---

# 👨‍💻 Author

**Vilas Oza**

Flutter Developer | Full Stack Developer

GitHub: https://github.com/oza24

```
```
