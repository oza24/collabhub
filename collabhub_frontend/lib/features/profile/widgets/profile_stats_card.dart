import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {

  final int workspaceCount;

  const ProfileStats({
    super.key,
    required this.workspaceCount,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceEvenly,

          children: [

            Column(
              children: [
                Text(
                  workspaceCount.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Text("Workspaces"),
              ],
            ),

          ],
        ),
      ),
    );
  }
}