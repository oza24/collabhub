import 'package:flutter/material.dart';

class ChannelTile extends StatelessWidget {

  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const ChannelTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(

      margin: const EdgeInsets.only(bottom: 15),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),

      child: ListTile(

        onTap: onTap,

        leading: const CircleAvatar(
          child: Icon(Icons.groups),
        ),

        title: Text(title),

        subtitle: Text(subtitle),

        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}