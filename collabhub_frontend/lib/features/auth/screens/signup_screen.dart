import 'package:collabhub/features/auth/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final usernameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;

  bool obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 50),

              IconButton(
                onPressed: () {
                  context.pop();
                },

                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.white,
                ),
              ),

              const SizedBox(height: 20),

              Container(
                height: 80,
                width: 80,

                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(22),
                ),

                child: const Icon(
                  Icons.person_add_alt_1_rounded,
                  color: AppColors.white,
                  size: 40,
                ),
              ),

              const SizedBox(height: 30),

              Text("Create Account ", style: textTheme.headlineLarge),

              const SizedBox(height: 10),

              Text(
                "Join CollabHub and start collaborating",
                style: textTheme.bodyMedium,
              ),

              const SizedBox(height: 40),

              TextField(
                controller: usernameController,

                style: const TextStyle(color: AppColors.white),

                decoration: const InputDecoration(
                  hintText: "Username",

                  prefixIcon: Icon(Icons.person_outline, color: AppColors.grey),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: emailController,

                style: const TextStyle(color: AppColors.white),

                decoration: const InputDecoration(
                  hintText: "Email Address",

                  prefixIcon: Icon(Icons.email_outlined, color: AppColors.grey),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: passwordController,

                obscureText: obscurePassword,

                style: const TextStyle(color: AppColors.white),

                decoration: InputDecoration(
                  hintText: "Password",

                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppColors.grey,
                  ),

                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },

                    icon: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,

                      color: AppColors.grey,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: confirmPasswordController,

                obscureText: obscureConfirmPassword,

                style: const TextStyle(color: AppColors.white),

                decoration: InputDecoration(
                  hintText: "Confirm Password",

                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppColors.grey,
                  ),

                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscureConfirmPassword = !obscureConfirmPassword;
                      });
                    },

                    icon: Icon(
                      obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,

                      color: AppColors.grey,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              ElevatedButton(

                onPressed: () async {

                  try {

                    final response =
                    await AuthService.signup(

                      username:
                      usernameController.text,

                      email:
                      emailController.text,

                      password:
                      passwordController.text,

                      role: "member",
                    );

                    print(
                        "Signup successful: ${response.data}"
                    );

                  } catch(e) {

                    if(e is DioException){

                      print(e.response?.data);

                    } else {

                      print(e.toString());
                    }
                  }
                },

                child: const Text("Create Account"),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(color: AppColors.grey),
                  ),

                  TextButton(
                    onPressed: () {
                      context.go('/login');
                    },

                    child: const Text("Login"),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
