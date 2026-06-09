import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class WorkspaceHeader extends StatelessWidget {
  final String workspacename;
  final String description;
  const WorkspaceHeader({super.key,required this.workspacename,required this.description});

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(

        gradient: const LinearGradient(
          colors: [
            Color(0xFF7C3AED),
            Color(0xFF9333EA),
          ],
        ),

        borderRadius: BorderRadius.circular(24),
      ),

      child: Row(

        children: [

          Container(

            height: 70,
            width: 70,

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),

            child: const Icon(
              Icons.workspaces_rounded,
              color: Colors.white,
              size: 34,
            ),
          ),

          const SizedBox(width: 18),

           Expanded(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  workspacename,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}