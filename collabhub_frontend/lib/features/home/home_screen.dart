import 'package:collabhub/features/home/dashboard_screen.dart';
import 'package:flutter/material.dart';

import '../../common/widgets/custom_appbar.dart';
import '../../common/widgets/custom_bottom_navbar.dart';
import '../../common/widgets/custom_appbar.dart';
import '../../common/widgets/custom_bottom_navbar.dart';
import '../../common/widgets/channel_tile.dart';

import '../chat/chat_screen.dart';
import '../profile/profile_screen.dart';
import '../workspace/workspace_detail_screen.dart';
import '../workspace/workspace_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int currentIndex = 0;

  final List<Widget> pages = [
    const DashboardScreen(),

    const ChatScreen(),

    const WorkspaceScreen(),

    const ProfileScreen(),

  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: pages[currentIndex],

      bottomNavigationBar: CustomBottomNavbar(

        currentIndex: currentIndex,

        onTap: (index) {

          setState(() {

            currentIndex = index;

          });
        },
      ),
    );
  }
}