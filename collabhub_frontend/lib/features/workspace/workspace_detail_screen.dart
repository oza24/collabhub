import 'package:collabhub/features/workspace/services/workspace_service.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';

import '../channel/services/channel_service.dart';

import 'widgets/channel_tile.dart';

import 'widgets/member_tile.dart';

import 'widgets/stats_card.dart';

import 'widgets/workspace_header.dart';

class WorkspaceDetailScreen extends StatefulWidget {
  final Map<String, dynamic> workspace;

  const WorkspaceDetailScreen({super.key, required this.workspace});

  @override
  State<WorkspaceDetailScreen> createState() => _WorkspaceDetailScreenState();
}

class _WorkspaceDetailScreenState extends State<WorkspaceDetailScreen> {
  final TextEditingController channelController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  List channels = [];

  bool isLoading = true;

  Future<void> createChannel() async {
    try {
      final workspaceId = widget.workspace["_id"];

      await ChannelService.createChannel(
        workspaceId: workspaceId,
        name: channelController.text,
      );
      Navigator.pop(context);
      channelController.clear();
      getChannels();
    } catch (e) {
      print("Create Channel Error: $e");
    }
  }

  // GET CHANNELS
  Future<void> getChannels() async {
    try {
      final workspaceId = widget.workspace["_id"];

      final response = await ChannelService.getWorkspaceChannels(
        workspaceId: workspaceId,
      );

      setState(() {
        channels = response.data["channels"];

        isLoading = false;
      });
    } catch (e) {
      print("Channels Error: $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addMembers() async {
    try {
      await WorkspaceService.addMember(
        workspaceId: widget.workspace["_id"],
        email: emailController.text,
      );

      Navigator.pop(context);
      emailController.clear();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Member Added")));
    } catch (e) {
      print("Add Member Error: $e");
    }
  }

  List members = [];

  void loadMembers() {
    setState(() {
      members = widget.workspace["members"] ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    getChannels();
    loadMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: Text(widget.workspace["name"]),

        leading: IconButton(
          onPressed: () {
            context.pop();
          },

          icon: const Icon(Icons.arrow_back),
        ),

        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: AppColors.background,
                    title: const Text("Add Member"),
                    content: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: "Enter Email",
                        hintStyle: TextStyle(color: Colors.white54),
                      ),
                    ),

                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },

                        child: const Text("Cancel"),
                      ),

                      ElevatedButton(
                        onPressed: addMembers,

                        child: const Text("Add"),
                      ),
                    ],
                  );
                },
              );
            },

            icon: const Icon(Icons.person_add),
          ),
          IconButton(
            onPressed: () {},

            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,

        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: AppColors.background,

                title: const Text("Create Channel"),

                content: TextField(
                  controller: channelController,

                  decoration: const InputDecoration(
                    hintText: "Channel Name",
                    hintStyle: TextStyle(color: Colors.white54),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),

                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      channelController.clear();
                    },
                    child: const Text("Cancel"),
                  ),

                  ElevatedButton(
                    onPressed: createChannel,
                    child: const Text("Create"),
                  ),
                ],
              );
            },
          );
        },

        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(18),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  WorkspaceHeader(
                    workspacename: widget.workspace["name"],

                    description: widget.workspace["description"],
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      StatsCard(
                        icon: Icons.groups,

                        title: "Members",

                        value: members.length.toString(),
                      ),

                      const SizedBox(width: 16),

                      StatsCard(
                        icon: Icons.chat,

                        title: "Channels",

                        value: channels.length.toString(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 34),

                  const Text(
                    "Channels",

                    style: TextStyle(
                      color: Colors.white,

                      fontSize: 24,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 18),

                  ListView.builder(
                    shrinkWrap: true,

                    physics: const NeverScrollableScrollPhysics(),

                    itemCount: channels.length,

                    itemBuilder: (context, index) {
                      final channel = channels[index];

                      return GestureDetector(
                        onTap: () {
                          context.push('/messages', extra: channel);
                        },

                        child: ChannelTile(
                          channelName: "# ${channel["name"]}",
                          lastMessage: "Last message preview goes here",
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 34),

                  const Text(
                    "Active Members",

                    style: TextStyle(
                      color: Colors.white,

                      fontSize: 24,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 18),

                  ListView.builder(
                    shrinkWrap: true,

                    physics: const NeverScrollableScrollPhysics(),

                    itemCount: members.length,

                    itemBuilder: (context, index) {
                      final member = members[index];

                      return MemberTile(
                        name: member["username"]!,
                        role: member["email"]!,
                        onTap: (){
                          context.push('/dm', extra: member);
                          print("Tapped on member: ${member["username"]}");
                        },

                      );
                    },
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
    );
  }
}
