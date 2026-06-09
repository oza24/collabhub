const express = require("express");

const mongoose = require("mongoose");

const cors = require("cors");

const dotenv = require("dotenv");

const http = require("http");

const { Server } = require("socket.io");

dotenv.config();

// SOCKET HANDLER
const socketHandler =require('./socket/socket_handler');


// ROUTES
const authRoutes =require("./routes/auth_routes");

const workspaceRoutes =require("./routes/workspace_routes");

const channelRoutes =require("./routes/channel_routes");

const messageRoutes =require("./routes/message_routes");

const conversationRoutes =require("./routes/conversation_routes");

const directMessageRoutes =require("./routes/direct_message_routes");

const chatRoutes =require("./routes/chat_routes");

const dashboardRoutes =require("./routes/dashboard_routes");

const profileRoutes =require("./routes/profile_routes");

const uploadRoutes =require("./routes/upload_routes");

const statusRoutes =require("./routes/status_routes");

const notificationRoutes = require("./routes/notification_routes");
// CONFIG



// EXPRESS APP
const app = express();


// HTTP SERVER
const server =
http.createServer(app);



// SOCKET SERVER
const io = new Server(server, {

   cors: {

      origin: "*",
   },
});


// CONNECT SOCKET HANDLER
socketHandler(io);


// MIDDLEWARE
app.use(cors());

app.use(express.json());


// ROUTES
app.use("/api/auth", authRoutes);

app.use("/api/workspace", workspaceRoutes);

app.use("/api/channel", channelRoutes);

app.use("/api/message", messageRoutes);

app.use("/api/conversation", conversationRoutes);

app.use("/api/dm", directMessageRoutes);

app.use("/api/chat", chatRoutes);

app.use("/api/dashboard", dashboardRoutes);

app.use("/api/profile", profileRoutes);

app.use("/api/upload",uploadRoutes);

app.use("/api/status",statusRoutes);

app.use("/api/notification", notificationRoutes);

// TEST ROUTE
app.get("/", (req, res) => {

    res.send(
      "Welcome to CollabHub API"
    );
});


// DATABASE
mongoose.connect(
   process.env.MongodbUri
)

.then(() => {

    console.log(
      "Connected to MongoDB"
    );
})

.catch((err) => {

    console.log(
        "MongoDB Error:",
        err
    );
});


// SERVER START
const PORT =
process.env.PORT || 3000;

server.listen(PORT, () => {

    console.log(
        `Server running on port ${PORT}`
    );
});