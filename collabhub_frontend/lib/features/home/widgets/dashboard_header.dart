import 'package:collabhub/common/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardHeader extends StatelessWidget {

  final String username;
  final int unreadCount;
  final VoidCallback? onNotificationTap;

  const DashboardHeader({
    super.key,
    required this.username,
    required this.unreadCount,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {

    return Row(

      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                " Welcome Back",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                username,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        unreadCount > 0
            ? Badge(
          backgroundColor: Colors.redAccent,

          textColor: Colors.white,

          offset: const Offset(-2, 2),

          label: Text(
            unreadCount > 99
                ? "99+"
                : unreadCount.toString(),

            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),

          child: IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              size: 28,
            ),

            splashRadius: 24,

            onPressed: onNotificationTap,
          ),
        )
            : IconButton(
          icon: const Icon(
            Icons.notifications_outlined,
            size: 28,
          ),

          splashRadius: 24,

          onPressed: onNotificationTap,
        ),
      ],
    );
  }
}