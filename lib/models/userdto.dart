import 'friend.dart';
import 'user.dart';

class UserDTO {
  final int id;
  final String guid;
  final bool isActive;
  final String balance;
  final int age;
  final String eyeColor;
  final String name;
  final String gender;
  final String company;
  final String email;
  final String phone;
  final String address;
  final String about;
  final String registered;
  final double latitude;
  final double longitude;
  final List<String> tags;
  final List<int> friends;
  final String favoriteFruit;

  UserDTO({
    required this.id,
    required this.guid,
    required this.isActive,
    required this.balance,
    required this.age,
    required this.eyeColor,
    required this.name,
    required this.gender,
    required this.company,
    required this.email,
    required this.phone,
    required this.address,
    required this.about,
    required this.registered,
    required this.latitude,
    required this.longitude,
    required this.tags,
    required this.friends,
    required this.favoriteFruit,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      id: json['id'],
      guid: json['guid'],
      isActive: json['isActive'],
      balance: json['balance'],
      age: json['age'],
      eyeColor: json['eyeColor'],
      name: json['name'],
      gender: json['gender'],
      company: json['company'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      about: json['about'],
      registered: json['registered'],
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      favoriteFruit: json['favoriteFruit'],
      tags:
          json['tags'] != null
              ? List<String>.from(json['tags'].map((x) => x.toString()))
              : [],
      friends:
          json['friends'] != null
              ? List<int>.from(json['friends'].map((x) => x['id'] as int))
              : [],
    );
  }

  User toUser(List<UserDTO> allUsers) {
    return User(
      id: id,
      isActive: isActive,
      age: age,
      eyeColor: eyeColor,
      name: name,
      company: company,
      email: email,
      phone: phone,
      address: address,
      about: about,
      registered: registered,
      latitude: latitude,
      longitude: longitude,
      friends:
          friends.map((friendId) {
            final friendData = allUsers.firstWhere(
              (user) => user.id == friendId,
            );
            return Friend(
              id: friendData.id,
              name: friendData.name,
              email: friendData.email,
              isActive: friendData.isActive,
            );
          }).toList(),
      favoriteFruit: favoriteFruit,
    );
  }
}
