import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class ChannelTile extends StatelessWidget {

  final String channelName;
  final String lastMessage;

  const ChannelTile({
    super.key,
    required this.channelName,
    required this.lastMessage,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      margin: const EdgeInsets.only(bottom: 16),

      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(20),
      ),

      child: ListTile(

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 8,
        ),

        leading: Container(

          height: 50,
          width: 50,

          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.15),
            shape: BoxShape.circle,
          ),

          child: const Icon(
            Icons.tag,
            color: AppColors.primary,
          ),
        ),

        title: Text(
          channelName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),

          child: Text(
            lastMessage,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white54,
          size: 16,
        ),
      ),
    );
  }
}