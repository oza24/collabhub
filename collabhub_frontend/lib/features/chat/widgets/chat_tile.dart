import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {

  final String name;
  final String message;
  final String time;
  final VoidCallback onTap;

  const ChatTile({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1A2035),
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),

      child: ListTile(
        onTap: onTap,

        leading: const CircleAvatar(
          radius: 28,
          child: Icon(Icons.person),
        ),

        title: Text(
          name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text(message),

        trailing: Text(time,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}