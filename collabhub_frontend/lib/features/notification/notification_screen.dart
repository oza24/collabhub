import 'package:collabhub/features/notification/service/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      final data = await NotificationService().getNotifications();

      setState(() {
        notifications = data;
        isLoading = false;
      });
    } catch (e) {
      print("Notification Error: $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),

      body: notifications.isEmpty
          ? const Center(child: Text("No  Unread Notifications Yet"))
          : ListView.builder(
              itemCount: notifications.length,

              itemBuilder: (context, index) {
                final notification = notifications[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

                  child: ListTile(

                    onTap: () async {

                      await NotificationService()
                          .markSingleNotificationRead(
                          notification["_id"]);

                      print(notification);
                      setState(() {
                        notifications.removeAt(index);
                      });
                      context.push(
                        "/dm",
                        extra: notification["sender"],
                      );
                    },
                    leading: const CircleAvatar(child: Icon(Icons.person)),

                    title: Text(
                      notification["sender"]?["username"] ?? "Unknown User",
                    ),

                    subtitle: Text(notification["message"] ?? ""),

                    trailing: notification["isRead"] == true
                        ? const Icon(Icons.done_all, color: Colors.green)
                        : const Icon(Icons.circle, size: 12, color: Colors.red),
                  ),
                );
              },
            ),
    );
  }
}
