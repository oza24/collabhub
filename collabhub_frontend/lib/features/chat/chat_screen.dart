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
  List filteredChats = [];
  bool isSearching = false;
  bool isLoading = true;

  Future<void> loadCurrentUser() async {
    final userId = await TokenStorage.getUserId();

    setState(() {
      currentUserId = userId ?? "";
    });
  }

  Future<void> getChats() async {
    try {
      final response = await ChatService.getMyChats();
      print(response.data);

      setState(() {
        chats = response.data["chats"];
        print("Chats Count: ${chats.length}");
        filteredChats = chats;
        isLoading = false;
      });
    } catch (e) {
      print("Chat Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void searchChats(String query) {
    setState(() {
      filteredChats = chats.where((chat) {
        final members = chat["members"] ?? [];

        final otherUser = members.firstWhere(
          (user) => user["_id"] != currentUserId,
          orElse: () => {},
        );

        final username = otherUser["username"] ?? "";

        return username.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
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
        title: isSearching
            ? TextField(
              autofocus: true,
              onChanged: searchChats,
              decoration: const InputDecoration(
                hintText: "Search chats...",
                border: InputBorder.none,
              ),
            )
            :const Text("Chats"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;

                  if(!isSearching){
                    filteredChats = chats;
                  }
                });
              },
              icon: const Icon(Icons.search)
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: LoadingWidget())
          : ListView.builder(
              itemCount: filteredChats.length,
              itemBuilder: (context, index) {
                final chat = filteredChats[index];
                final members = chat["members"] ?? [];

                final otheruser = members.firstWhere(
                  (user) => user["_id"] != currentUserId,
                  orElse: () => {},
                );

                if (otheruser.isEmpty) {
                  return const SizedBox.shrink();
                }
                final lastTime = DateTime.parse(chat["lastMessageTime"]);
                return ChatTile(
                  name: otheruser["username"],
                  message: chat["lastMessage"] ?? "",
                  time:
                      "${lastTime.hour}:${lastTime.minute.toString().padLeft(2, '0')}",
                  onTap: () {
                    context.push(
                      "/dm",
                      extra: Map<String, dynamic>.from(otheruser),
                    );
                  },
                );
              },
            ),
    );
  }
}
