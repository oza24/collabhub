import 'package:collabhub/features/chat/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/loading_widget.dart';
import '../../core/storage/token_storage.dart';
import 'message_screen.dart';

import 'widgets/chat_tile.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String currentUserId = "";


  List chats = [];
  bool isLoading = true;

  Future<void> loadCurrentUser() async {
    final userId = await TokenStorage.getUserId();

    setState(() {
      currentUserId = userId ?? "";
    });
  }



  Future<void> getChats() async {
    try{
      final response = await ChatService.getMyChats();
      print(response.data);

      setState(() {
        chats=response.data["chats"];
        print("Chats Count: ${chats.length}");
        isLoading = false;
      });

    }
    catch(e){
      print("Chat Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadCurrentUser().then((_) => getChats());

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),

      body: isLoading?
        const Center(child: LoadingWidget())
        :
      ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];
            final members = chat["members"] ?? [];

            final otheruser = members.firstWhere(
                  (user) => user["_id"] != currentUserId,
              orElse: () => {},
            );

            if (otheruser.isEmpty) {
              return const SizedBox.shrink();
            }
            final lastTime= DateTime.parse(chat["lastMessageTime"]);
            return ChatTile(
              name: otheruser["username"],
              message: chat["lastMessage"]?? "",
              time: "${lastTime.hour}:${lastTime.minute.toString().padLeft(2, '0')}",
              onTap: () {
                context.push(
                  "/dm",
                  extra: Map<String, dynamic>.from(otheruser),
                );
              },
            );

          }
        )
    );

  }
}
