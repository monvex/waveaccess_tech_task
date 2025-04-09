import 'package:flutter/material.dart';
import '../models/user.dart';
import '../screens/user_detail_screen.dart';

class UserTile extends StatelessWidget {
  final User user;

  const UserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: Icon(
        Icons.circle,
        color: user.isActive ? Colors.green : Colors.red,
        size: 12,
      ),
      enabled: user.isActive,
      onTap:
          user.isActive
              ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserDetailScreen(user: user),
                  ),
                );
              }
              : null,
    );
  }
}
