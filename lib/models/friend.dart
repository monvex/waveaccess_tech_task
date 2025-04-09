import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waveaccess_tech_task/services/user_service.dart';
import 'user.dart';

class Friend {
  final int id;
  final String name;
  final String email;
  final bool isActive;

  Friend({
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
  });
}

extension FriendExtension on Friend {
  User? getFullUser(BuildContext context) {
    final userService = Provider.of<UserService>(context, listen: false);
    try {
      return userService.users.firstWhere((user) => user.id == id);
    } catch (_) {
      return null;
    }
  }
}
