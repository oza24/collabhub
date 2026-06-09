import 'package:flutter/material.dart';

import 'recent_chat_card.dart';

class RecentChatsSection extends StatelessWidget {
  const RecentChatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        const Text(
          "Recent Chats",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 16),

        RecentChatCard(
          name: "Rahul Sharma",
          message: "Let's deploy today",
          onTap: () {},
        ),

        const SizedBox(height: 12),

        RecentChatCard(
          name: "Aman Verma",
          message: "Meeting at 5 PM",
          onTap: () {},
        ),
      ],
    );
  }
}
