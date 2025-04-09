import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/userdto.dart';
import '../models/user.dart';

class UserService {
  static const _url =
      'https://firebasestorage.googleapis.com/v0/b/candidates--questionnaire.appspot.com/o/users.json?alt=media&token=e3672c23-b1a5-4ca7-bb77-b6580d75810c';

  static const _cacheKey = 'cached_users';
  List<UserDTO> _usersFullInfo = [];
  List<User> _users = [];
  List<User> get users => _users;

  Future<void> getUsers({bool forceRefresh = false}) async {
    final prefs = await SharedPreferences.getInstance();

    String? jsonString;

    if (!forceRefresh && prefs.containsKey(_cacheKey)) {
      jsonString = prefs.getString(_cacheKey);
    } else {
      final response = await http.get(Uri.parse(_url));
      if (response.statusCode == 200) {
        jsonString = response.body;
        await prefs.setString(_cacheKey, jsonString);
      } else {
        throw Exception('Ошибка загрузки пользователей');
      }
    }

    final List<dynamic> data = jsonDecode(jsonString!);

    _usersFullInfo = (data).map((i) => UserDTO.fromJson(i)).toList();
    _users =
        _usersFullInfo
            .map((userDTO) => userDTO.toUser(_usersFullInfo))
            .toList();
  }
}
