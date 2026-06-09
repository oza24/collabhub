import 'dart:io';

import 'package:collabhub/core/constants/app_colors.dart';
import 'package:collabhub/features/chat/services/direct_message_service.dart';
import 'package:collabhub/features/chat/widgets/message_bubble.dart';
import 'package:collabhub/features/chat/widgets/message_input.dart';
import 'package:dio/src/response.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/network/dio_client.dart';
import '../../core/storage/token_storage.dart';
import '../../core/socket/socket_service.dart';

class DirectMessageScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const DirectMessageScreen({super.key, required this.user});

  @override
  State<DirectMessageScreen> createState() => _DirectMessageScreenState();
}

class _DirectMessageScreenState extends State<DirectMessageScreen> {
  String currentUserId = "";
  String conversationId = "";

  bool isLoading = true;

  bool isOnline = false;
  String lastSeen = "";

  void joinConversation() {
    if (conversationId.isEmpty) return;

    SocketService.socket.emit('joinConversation', conversationId);
    print("Joined Conversation: $conversationId");
  }

  void listenDirectMessages() {
    SocketService.socket.on('receiveDirectMessage', (data) {
      setState(() {
        final exists = messages.any((m) => m["_id"] == data["_id"],);
        if(!exists) {
          messages.add(data);
        }
      });
    });
  }

  Future<void> loadStatus() async {
    try {
      final response =
      await DirectMessageService
          .getUserStatus(
        userId: widget.user["_id"],
      );
      setState(() {
        isOnline =
        response.data["isOnline"];
        lastSeen =
            response.data["lastSeen"] ?? "";
      });
    }
    catch (e) {
      print(
        "Status Error: $e",
      );
    }
  }

  Future<void> loadCurrentUser() async {
    final userId = await TokenStorage.getUserId();

    setState(() {
      currentUserId = userId ?? "";
    });
  }

  Future<void> createConversation() async {
    try {
      final response = await DirectMessageService.createConversation(
        receiverId: widget.user["_id"],
      );

      setState(() {
        conversationId = response.data["conversation"]["_id"];
      });
      joinConversation();

      getMessages();
    } catch (e) {
      print("Create Conversation Error: $e");
    }
  }

  Future<void> getMessages() async {
    try {

      final response =
      await DirectMessageService.getMessages(
        conversationId: conversationId,
      );

      setState(() {
        messages = response.data["messages"];
        isLoading = false;
      });

      await DirectMessageService.markMessagesRead(
        conversationId: conversationId,
      );

      // Reload after marking read
      final refreshed =
      await DirectMessageService.getMessages(
        conversationId: conversationId,
      );

      setState(() {
        messages = refreshed.data["messages"];
      });

    } catch (e) {
      print("Get Messages Error: $e");
    }
  }

  final TextEditingController controller = TextEditingController();

  List messages = [];

  Future<void> sendMessage() async {
    if (controller.text.trim().isEmpty) {
      return;
    }
    try {
      final text = controller.text.trim();
      // SAVE TO DATABASE
      final response = await DirectMessageService.sendMessage(
        conversationId: conversationId,
        text: text,
      );

      setState(() {
        messages.add(response.data["data"]);
      });

      // REALTIME SOCKET
      SocketService.socket.emit('sendDirectMessage', {
        "_id": response.data["data"]["_id"],
        "text": text,
        "conversationId": conversationId,
        "sender": response.data["data"]["sender"],
      });

      controller.clear();
    } catch (e) {
      print("DM Error: $e");
    }
  }

  Future<void> pickFile() async {
    print("Attach Clicked");
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    print("Result: $result");
    if(result == null){
      return;
    }
    final file = File(
      result.files.single.path!,
    );
    print("Picked File: ${file.path}");
    await sendFileMessage(file);
  }

  Future<void> sendFileMessage(File file) async {
    try {
      print("UPLOAD START");

      final uploadData = await DirectMessageService.uploadFile(file);

      print("UPLOAD SUCCESS");
      print(uploadData);

      final response = await DirectMessageService.sendMessage(
        conversationId: conversationId,
        text: "",
        messageType: "file",
        fileUrl: uploadData["fileUrl"],
        fileName: uploadData["fileName"],
      );
      print("MESSAGE SENT");
      print(response.data);

      setState(() {
        messages.add(response.data["data"]);
      });
    }
    catch (e) {
      print("File Upload Error: $e");
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    loadCurrentUser();
    listenDirectMessages();
    createConversation();
    loadStatus();
  }

  @override
  void dispose() {
    SocketService.socket.off('receiveDirectMessage');
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.deepPurple,
              child: Icon(Icons.person, color: Colors.white),
            ),

            const SizedBox(width: 10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user["username"]?.toString() ?? "Unknown User",
                ),
                Text(
                  isOnline ? "🟢 Online" : "⚫ Offline",
                  style:
                  const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),

          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),

              itemCount: messages.length,

              itemBuilder: (context, index) {
                final message = messages[index];
                if (message["messageType"] == "file") {
                  return Card(
                    child: ListTile(
                      onTap: () async {
                        final url =
                        message["fileUrl"];
                        if(url != null) {
                          await launchUrl(
                            Uri.parse(url),
                            mode: LaunchMode.externalApplication,
                          );
                        }

                      },

                      leading: const Icon(
                        Icons.insert_drive_file,
                      ),

                      title: Text(
                        message["fileName"] ?? "File",
                      ),

                      subtitle: const Text(
                        "Tap to open",
                      ),
                    ),
                  );
                }

                return MessageBubble(
                  text: message["text"] ?? "",
                  isMe: message["sender"]["_id"] == currentUserId,
                  isRead: message["isRead"] ?? false,
                );
              },
            ),
          ),

          MessageInput(
            controller: controller,

            onSend: sendMessage,

            onChanged: (value) {
              setState(() {});
            },
            onAttach: pickFile,
          ),
        ],
      ),
    );
  }
}
