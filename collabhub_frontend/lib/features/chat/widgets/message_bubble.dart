import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {

  final String text;
  final bool isMe;
  final bool? isRead;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isMe,
    this.isRead,
  });

  @override
  Widget build(BuildContext context) {

    return Align(
      alignment:
      isMe
          ? Alignment.centerRight
          : Alignment.centerLeft,

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),

        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),

        decoration: BoxDecoration(
          color:
          isMe
              ? Colors.deepPurple
              : Colors.grey.shade800,

          borderRadius:
          BorderRadius.circular(16),
        ),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.end,

          children: [

            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),

            if (isMe && isRead != null)
              Padding(
                padding:
                const EdgeInsets.only(
                  top: 4,
                ),

                child: Icon(
                  isRead!
                      ? Icons.done_all
                      : Icons.done,

                  size: 16,

                  color:
                  isRead!
                      ? Colors.blue
                      : Colors.white70,
                ),
              ),
          ],
        ),
      ),
    );
  }
}