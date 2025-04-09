import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import '../widgets/user_tile.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});
  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late UserService _userService; // Добавляем поле для UserService
  List<User> _users = [];
  bool _loading = true;

  Future<void> _loadUsers({bool forceRefresh = false}) async {
    setState(() => _loading = true);
    try {
      await _userService.getUsers(forceRefresh: forceRefresh);
      setState(() {
        _users = _userService.users;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print('Ошибка загрузки данных: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _userService = Provider.of<UserService>(context, listen: false);
    if (_loading) {
      _loadUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Пользователи'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadUsers(forceRefresh: true),
          ),
        ],
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  return UserTile(user: _users[index]);
                },
              ),
    );
  }
}
