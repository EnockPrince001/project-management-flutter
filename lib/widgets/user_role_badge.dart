import 'package:flutter/material.dart';

class UserRoleBadge extends StatelessWidget {
  final String role;
  const UserRoleBadge({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    switch (role.toLowerCase()) {
      case 'admin':
        badgeColor = Colors.redAccent.shade400;
        break;
      case 'member':
        badgeColor = Colors.blueAccent.shade400;
        break;
      default:
        badgeColor = Colors.grey.shade600;
    }

    return Chip(
      label: Text(
        role,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      ),
      backgroundColor: badgeColor,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      labelPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}
