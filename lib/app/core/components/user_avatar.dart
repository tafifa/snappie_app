import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String username;
  final String? avatarUrl;
  final double radius;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;

  const UserAvatar({
    super.key,
    required this.username,
    this.avatarUrl,
    this.radius = 20,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? Colors.blue[100],
      backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
          ? NetworkImage(avatarUrl!)
          : null,
      child: avatarUrl == null || avatarUrl!.isEmpty
          ? Text(
              username.isNotEmpty ? username[0].toUpperCase() : '?',
              style: TextStyle(
                color: textColor ?? Colors.blue[700],
                fontWeight: FontWeight.bold,
                fontSize: fontSize ?? (radius * 0.6),
              ),
            )
          : null,
    );
  }
}
