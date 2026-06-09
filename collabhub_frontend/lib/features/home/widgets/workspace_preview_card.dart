import 'package:collabhub/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class WorkspacePreviewCard extends StatelessWidget {
  final String name;
  final int members;
  final int channels;
  final VoidCallback onTap;

  const WorkspacePreviewCard({
    super.key,
    required this.name,
    required this.members,
    required this.channels,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(20),

      child: Container(
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
          ],
        ),

        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,

              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.1),

                borderRadius: BorderRadius.circular(14),
              ),

              child: const Icon(
                Icons.workspaces_outline,
                color: Colors.deepPurple,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    name,

                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "$members Members • $channels Channels",

                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
