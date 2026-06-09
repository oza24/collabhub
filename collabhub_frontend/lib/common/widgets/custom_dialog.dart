import 'package:flutter/material.dart';

class CustomDialog {

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String content,
  }) async {

    await showDialog(

      context: context,

      builder: (context) {

        return AlertDialog(

          title: Text(title),

          content: Text(content),

          actions: [

            TextButton(

              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("OK"),
            ),

          ],
        );
      },
    );
  }
}