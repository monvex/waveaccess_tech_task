import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waveaccess_tech_task/services/user_service.dart';
import 'package:waveaccess_tech_task/screens/user_list_screen.dart';

void main() {
  runApp(
    Provider<UserService>(create: (_) => UserService(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'User List App', home: const UserListScreen());
  }
}
