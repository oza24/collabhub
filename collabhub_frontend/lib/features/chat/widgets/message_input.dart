import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final ValueChanged<String> onChanged;
  final VoidCallback onAttach;

  const MessageInput({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onChanged,
    required this.onAttach,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),

      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,

              decoration: InputDecoration(
                hintText: "Type a message",

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          IconButton(
            icon:
            const Icon(
              Icons.attach_file,
            ),
            onPressed: onAttach,
          ),

          const SizedBox(width: 10),

          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.deepPurple,
            child: IconButton(
              onPressed: onSend,
              icon: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
