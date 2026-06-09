import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {

  final double radius;
  final IconData icon;

  const UserAvatar({
    super.key,
    this.radius = 30,
    this.icon = Icons.person,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(

      radius: radius,

      child: Icon(
        icon,
        size: radius,
      ),
    );
  }
}