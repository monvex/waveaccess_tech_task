import 'friend.dart';

class User {
  final int id;
  final bool isActive;
  final int age;
  final String eyeColor;
  final String name;
  final String company;
  final String email;
  final String phone;
  final String address;
  final String about;
  final String registered;
  final double latitude;
  final double longitude;
  final List<Friend> friends;
  final String favoriteFruit;

  User({
    required this.id,
    required this.isActive,
    required this.age,
    required this.eyeColor,
    required this.name,
    required this.company,
    required this.email,
    required this.phone,
    required this.address,
    required this.about,
    required this.registered,
    required this.latitude,
    required this.longitude,
    required this.friends,
    required this.favoriteFruit,
  });
}
