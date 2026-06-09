import 'package:collabhub/features/home/widgets/activity_card.dart';
import 'package:collabhub/features/home/widgets/dashboard_header.dart';
import 'package:collabhub/features/home/widgets/recent_chat_card.dart';
import 'package:collabhub/features/home/widgets/recent_chats_section.dart';
import 'package:collabhub/features/home/widgets/stats_card.dart';
import 'package:collabhub/features/home/widgets/workspace_preview_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:collabhub/features/home/services/dashboard_service.dart';
import 'package:go_router/go_router.dart';

import '../../core/storage/token_storage.dart';
import '../notification/service/notification_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic> dashboard = {};
  bool isLoading = true;
  String currentUserId = "";
  int unreadCount = 0;

  Future<void> loadCurrentUser() async {
    final userId = await TokenStorage.getUserId();
    setState(() {
      currentUserId = userId ?? "";
    });

  }

  Future<void> getDashboard() async {
    try {
      final response =
      await DashboardService.getDashboard();
      setState(() {
        dashboard = response.data;
        isLoading = false;
      });
    } catch (e) {
      print("Dashboard Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadUnreadCount() async {
    final count = await NotificationService().getUnreadCount();
    setState(() {
      unreadCount = count;
    });
  }

  @override
  void initState() {
    super.initState();

    loadCurrentUser().then((_) {
      getDashboard();
      loadUnreadCount();
    });
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DashboardHeader(
                    username: dashboard["username"] ?? "User",
                    unreadCount: unreadCount,
                    onNotificationTap: () async {
                      await context.push("/notifications",);
                      loadUnreadCount();
                    },

                ),

                const SizedBox(height: 24),

                 GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.25,
                   children: [
                     StatsCard(
                       title: "Workspaces",
                       value: "${dashboard["workspaceCount"] ?? 0}",
                       icon: Icons.workspaces,
                     ),

                     StatsCard(
                       title: "Channels",
                       value: "${dashboard["channelCount"] ?? 0}",
                       icon: Icons.tag,
                     ),

                     StatsCard(
                       title: "Messages",
                       value: "${dashboard["messageCount"] ?? 0}",
                       icon: Icons.message,
                     ),

                     StatsCard(
                       title: "Members",
                       value: "${dashboard["memberCount"] ?? 0}",
                       icon: Icons.people,
                     ),
                   ],
                ),

                const SizedBox(height: 24),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  "Recent Workspaces",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                ...(dashboard["recentWorkspaces"] ?? [])
                    .map<Widget>((workspace) {

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),

                    child: WorkspacePreviewCard(

                      name: workspace["name"],

                      members:
                      workspace["members"]?.length ?? 0,

                      channels:
                      workspace["channelCount"] ?? 0,

                      onTap: () {
                        context.push("/workspace/${workspace["_id"]}",
                        extra: workspace);

                      },
                    ),
                  );
                }).toList(),
              ],
            ),

                const SizedBox(height: 24),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Recent Chats",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    ...(dashboard["recentChats"] ?? [])
                        .map<Widget>((chat) {

                      final members = chat["members"] ?? [];

                      final otherUser = members.firstWhere(
                            (user) =>
                        user["_id"] != currentUserId,
                        orElse: () => {},
                      );

                      return Padding(
                        padding:
                        const EdgeInsets.only(bottom: 12),

                        child: RecentChatCard(
                          name:
                          otherUser["username"] ??
                              "Unknown",

                          message:
                          chat["lastMessage"] ?? "",

                          onTap: () {


                            context.push(
                              "/dm",
                              extra: otherUser,
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ],
                ),

                const SizedBox(height: 24),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                "Recent Activity",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              ActivityCard(
                title: "Rahul created #backend",
                time: "2 min ago",
                icon: Icons.add_circle,
              ),

              ActivityCard(
                title: "Aman joined Flutter Team",
                time: "15 min ago",
                icon: Icons.group_add,
              ),

              ActivityCard(
                title: "Priya sent a message",
                time: "30 min ago",
                icon: Icons.message,
              ),
            ],
          ),

              ],

          ),
        ),
      ),
    );
  }
}
