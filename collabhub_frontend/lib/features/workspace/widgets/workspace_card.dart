import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class WorkspaceCard extends StatelessWidget {

  final String name;

  final String description;

  final VoidCallback onTap;

  const WorkspaceCard({

    super.key,

    required this.name,

    required this.description,

    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: onTap,

      child: Container(

        margin: const EdgeInsets.only(bottom: 18),

        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(

          gradient: const LinearGradient(

            colors: [
              Color(0xFF7C3AED),
              Color(0xFF9333EA),
            ],
          ),

          borderRadius:
          BorderRadius.circular(24),
        ),

        child: Row(

          children: [

            Container(

              height: 65,
              width: 65,

              decoration: BoxDecoration(

                color:
                Colors.white.withOpacity(0.2),

                borderRadius:
                BorderRadius.circular(18),
              ),

              child: const Icon(

                Icons.workspaces_rounded,

                color: Colors.white,

                size: 32,
              ),
            ),

            const SizedBox(width: 18),

            Expanded(

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(

                    name,

                    style: const TextStyle(

                      color: Colors.white,

                      fontSize: 22,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(

                    description,

                    style: const TextStyle(

                      color: Colors.white70,

                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}