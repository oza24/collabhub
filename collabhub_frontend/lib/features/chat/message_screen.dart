import 'package:collabhub/core/socket/socket_service.dart';
import 'package:collabhub/features/chat/services/message_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import 'widgets/message_bubble.dart';
import 'widgets/message_input.dart';
import '../../core/storage/token_storage.dart';

class MessageScreen extends StatefulWidget {

  final Map<String,dynamic> channel;

  const MessageScreen({
    super.key,
    required this.channel,
  });

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {

  final TextEditingController messageController = TextEditingController();
  String currentUserId = "";
  String typingUser = "";

  void joinChannel(){
    SocketService.socket.emit(
      'joinChannel',widget.channel["_id"],
    );
  }

  void listenTyping() {
    SocketService.socket.on('typing', (data) {
      setState(() {
        typingUser = data["username"];
      });

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            typingUser = "";
          });
        }
      });

    });
  }

  void listenMessages() {
    SocketService.socket.on('receiveMessage', (data) {
      setState(() {
        messages.add(data);
        });
      },
    );
  }


  Future<void> loadCurrentUser() async {

    final userId =
    await TokenStorage.getUserId();

    setState(() {

      currentUserId =
          userId ?? "";
    });
  }

  List messages = [];
  bool is_loading = true;

  Future<void> getChannelMessages() async {
    try {
      final response = await MessageService.getChannelMessages(channelId: widget.channel["_id"]);
      setState(() {
        messages = response.data["messages"];
        is_loading = false;
      });
    } catch (e) {
      print("Error fetching channel messages: $e");
      setState(() {
        is_loading = false;
      });
    }
  }

  Future<void> sendMessage() async {
    if(messageController.text.trim().isEmpty) {
      return;
    }
    SocketService.socket.emit('sendMessage',
      {
        'text': messageController.text,
        'sender': currentUserId,
        'channel': widget.channel["_id"],
      },
    );
    messageController.clear();
  }

  @override
  void initState() {
    super.initState();
    loadCurrentUser();
    getChannelMessages();
    joinChannel();
    listenMessages();
    listenTyping();
  }

  @override
  void dispose() {
    SocketService.socket.off(
      'receiveMessage',
    );
    messageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_ios_new)),
        title: Text(
          "#${widget.channel["name"]}",
        ),
      ),

      body: Column(

        children: [

          Expanded(
            child: is_loading
                ? const Center(child: CircularProgressIndicator())
                :ListView.builder(

              padding: const EdgeInsets.all(16),

              itemCount: messages.length,

              itemBuilder: (context, index) {

                final message = messages[index];

                return MessageBubble(

                  text: message["text"],

                  isMe: message["sender"]["_id"] == currentUserId,

                );
              },
            ),
          ),

            if(typingUser.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text("$typingUser is typing..."),
              ),

          MessageInput(

            controller: messageController,

            onSend: () {
              sendMessage();
              // Implement send message functionality here
            },
            onAttach: (){},

            onChanged: (text) {
              SocketService.socket.emit('typing', {
                'username': "User", // You can replace this with the actual username
                'channel': widget.channel["_id"],
              });
            },
          ),

        ],
      ),
    );
  }
}