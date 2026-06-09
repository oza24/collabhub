import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class StatsCard extends StatelessWidget {

  final IconData icon;
  final String title;
  final String value;

  const StatsCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {

    return Expanded(

      child: Container(

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(22),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Icon(
              icon,
              color: AppColors.primary,
              size: 30,
            ),

            const SizedBox(height: 18),

            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}