import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/auth_service.dart';


class OtpScreen extends StatefulWidget {

  final String email;

  const OtpScreen({
    super.key,
    required this.email,
  });

  @override
  State<OtpScreen> createState() =>
      _OtpScreenState();
}

class _OtpScreenState
    extends State<OtpScreen> {

  final otpController =
  TextEditingController();

  bool isLoading = false;

  Future<void> verifyOtp() async {

    try {

      setState(() {
        isLoading = true;
      });

      await AuthService.verifyOtp(

        email: widget.email,

        otp:
        otpController.text.trim(),

      );

      setState(() {
        isLoading = false;
      });

      context.push(
        "/reset-password",
        extra: {
          "email": widget.email,
          "otp": otpController.text.trim(),

        },

      );

    } catch (e) {

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content:
          Text("$e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title:
        const Text(
            "Verify OTP"),
      ),

      body: Padding(

        padding:
        const EdgeInsets.all(20),

        child: Column(

          children: [

            const SizedBox(
                height: 30),

            const Text(

              "Enter OTP",

              style: TextStyle(
                fontSize: 26,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(
                height: 20),

            TextField(

              controller:
              otpController,

              keyboardType:
              TextInputType.number,

              decoration:
              const InputDecoration(

                labelText:
                "OTP",

                border:
                OutlineInputBorder(),
              ),
            ),

            const SizedBox(
                height: 25),

            SizedBox(

              width:
              double.infinity,

              child:
              ElevatedButton(

                onPressed:
                verifyOtp,

                child:
                isLoading

                    ? const CircularProgressIndicator()

                    : const Text(
                  "Verify OTP",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}