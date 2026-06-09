import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../services/auth_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState
    extends State<ResetPasswordScreen> {

  final TextEditingController passwordController =
  TextEditingController();

  final TextEditingController confirmController =
  TextEditingController();

  bool isLoading = false;

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  Future<void> resetPassword() async {

    if (passwordController.text.trim().isEmpty ||
        confirmController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill all fields",
          ),
        ),
      );

      return;
    }

    if (passwordController.text !=
        confirmController.text) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Passwords do not match",
          ),
        ),
      );

      return;
    }

    try {

      setState(() {
        isLoading = true;
      });

      await AuthService.resetPassword(
        email: widget.email,
        otp: widget.otp,
        password: passwordController.text.trim(),
      );

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Password Reset Successful",
          ),
        ),
      );

      context.go("/login");

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
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          "Reset Password",
        ),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const SizedBox(height: 30),

            const Text(
              "Create New Password",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Your new password must be different from your previous password.",
            ),

            const SizedBox(height: 30),

            TextField(

              controller:
              passwordController,

              obscureText:
              obscurePassword,

              decoration:
              InputDecoration(

                labelText:
                "New Password",

                border:
                const OutlineInputBorder(),

                prefixIcon:
                const Icon(Icons.lock),

                suffixIcon:
                IconButton(

                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),

                  onPressed: () {

                    setState(() {

                      obscurePassword =
                      !obscurePassword;

                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(

              controller:
              confirmController,

              obscureText:
              obscureConfirmPassword,

              decoration:
              InputDecoration(

                labelText:
                "Confirm Password",

                border:
                const OutlineInputBorder(),

                prefixIcon:
                const Icon(Icons.lock),

                suffixIcon:
                IconButton(

                  icon: Icon(
                    obscureConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),

                  onPressed: () {

                    setState(() {

                      obscureConfirmPassword =
                      !obscureConfirmPassword;

                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(

              width: double.infinity,
              height: 50,

              child: ElevatedButton(

                onPressed:
                isLoading
                    ? null
                    : resetPassword,

                child:
                isLoading

                    ? const CircularProgressIndicator()

                    : const Text(
                  "Reset Password",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}