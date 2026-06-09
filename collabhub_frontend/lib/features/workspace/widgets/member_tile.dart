import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class MemberTile extends StatelessWidget {

  final String name;
  final String role;
  final VoidCallback onTap;

  const MemberTile({
    super.key,
    required this.name,
    required this.role,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: Container(

        margin: const EdgeInsets.only(bottom: 14),

        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(18),
        ),

        child: ListTile(

          leading: const CircleAvatar(
            backgroundColor: AppColors.primary,
            child: Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),

          title: Text(
            name,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),

          subtitle: Text(
            role,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),

          trailing: Container(
            height: 10,
            width: 10,

            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}