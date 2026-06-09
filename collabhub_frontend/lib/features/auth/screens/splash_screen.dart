import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(seconds: 3),
          () {
        context.go('/login');
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(

      backgroundColor: AppColors.background,

      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Container(
              height: 110,
              width: 110,

              decoration: BoxDecoration(

                color: AppColors.primary,

                borderRadius: BorderRadius.circular(28),

                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),

              child: const Icon(
                Icons.chat_bubble_rounded,
                color: AppColors.white,
                size: 55,
              ),
            ),

            const SizedBox(height: 28),

            Text(
              "CollabHub",
              style: textTheme.headlineLarge,
            ),

            const SizedBox(height: 12),

            Text(
              "Work together. Anywhere.",
              style: textTheme.bodyMedium,
            ),

            const SizedBox(height: 40),

            const CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}