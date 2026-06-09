import 'package:collabhub/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {

  final String title;
  final String value;
  final IconData icon;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(

        // color: Colors.white,
        color: AppColors.primary,

        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),

      child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Icon(
              icon,
              size: 28,
            ),

            const SizedBox(height: 16),

            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
      ),
    );


  }
}