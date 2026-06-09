import 'package:collabhub/common/widgets/user_avatar.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {

  final String username;
  final String email;
  final String bio;

  const ProfileHeader({
    super.key,
    required this.username,
    required this.email,
    required this.bio,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        const UserAvatar(
          radius: 50,
          icon: Icons.person,
        ),

        const SizedBox(height: 15),

        Text(
          username,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          email,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          bio.isEmpty
              ? "No bio added yet"
              : bio,
        ),
      ],
    );
  }
}