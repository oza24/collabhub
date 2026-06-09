import 'package:flutter/material.dart';

class CustomBottomNavbar extends StatelessWidget {

  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(

      currentIndex: currentIndex,

      onTap: onTap,

      type: BottomNavigationBarType.fixed,

      items: const [

        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chats',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.workspaces),
          label: 'Workspace',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),

      ],
    );
  }
}