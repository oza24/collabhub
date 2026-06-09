import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {

  final TextEditingController emailController =
  TextEditingController();

  bool isLoading = false;

  Future<void> sendOtp() async {
    if (emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter email"),
        ),
      );
      return;
    }
    try {

      setState(() {
        isLoading = true;
      });

      await AuthService.forgotPassword(
        email: emailController.text.trim(),
      );

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("OTP Sent Successfully"),
        ),
      );

      context.push(
        "/verify-otp",
        extra: emailController.text.trim(),
      );

    } catch (e) {

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error: $e",
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          "Forgot Password",
        ),
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 30),

            const Text(
              "Reset Password",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Enter your registered email address and we'll send you an OTP.",
            ),

            const SizedBox(height: 30),

            TextField(
              controller: emailController,
              keyboardType:
              TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
                prefixIcon:
                Icon(Icons.email),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(

              width: double.infinity,
              height: 50,
              child: ElevatedButton(

                onPressed: isLoading
                    ? null
                    : sendOtp,

                child:
                isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                  "Send OTP",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}