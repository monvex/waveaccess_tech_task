import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waveaccess_tech_task/models/friend.dart';
import 'package:waveaccess_tech_task/widgets/user_tile.dart';
import '../models/user.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    Future<void> launchEmail() async {
      final email = user.email.trim();
      if (email.isEmpty) return;

      final Uri emailUri = Uri(scheme: 'mailto', path: email);

      try {
        if (await canLaunchUrl(emailUri)) {
          await launchUrl(emailUri);
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Не удалось открыть почтовый клиент')),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Ошибка: ${e.toString()}')));
        }
      }
    }

    Future<void> launchPhone() async {
      final status = await Permission.phone.request();

      if (status.isGranted) {
        final phoneNumber = user.phone.replaceAll(RegExp(r'[^0-9+]'), '');
        if (phoneNumber.isEmpty) return;

        final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

        try {
          if (await canLaunchUrl(phoneUri)) {
            await launchUrl(phoneUri);
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Не удалось открыть номер: $phoneNumber'),
                ),
              );
            }
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Ошибка: ${e.toString()}')));
          }
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Разрешение на звонки не предоставлено')),
          );
        }
        await openAppSettings();
      }
    }

    Future<void> launchMap() async {
      final status = await Permission.location.request();
      if (!status.isGranted) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Разрешение на геолокацию не предоставлено'),
            ),
          );
        }
        await openAppSettings();
      }

      final Uri mapsUri = Uri(
        scheme: 'geo',
        path: '${user.latitude},${user.longitude}',
        queryParameters: {'q': '${user.latitude},${user.longitude}'},
      );

      try {
        if (await canLaunchUrl(mapsUri)) {
          await launchUrl(mapsUri);
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Не удалось открыть приложение "Карты"')),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text("Детали")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Имя: ${user.name}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            Text(
              'Возраст: ${user.age}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 8),
            Text(
              'Компания: ${user.company}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: launchEmail,
              child: Text(
                'Почта: ${user.email}',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: launchPhone,
              child: Text(
                'Телефон: ${user.phone}',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Адрес: ${user.address}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 8),
            Text(
              'О себе: ${user.about}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Цвет глаз: ',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Icon(
                  Icons.circle,
                  color:
                      user.eyeColor == 'brown'
                          ? Colors.brown
                          : user.eyeColor == 'green'
                          ? const Color.fromARGB(255, 6, 88, 9)
                          : Colors.blue,
                  size: 16,
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Любимый фрукт: ',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SvgPicture.asset(
                  user.favoriteFruit == 'apple'
                      ? "assets/icons/RedApple.svg"
                      : user.favoriteFruit == 'banana'
                      ? "assets/icons/Banana.svg"
                      : "assets/icons/Strawberry.svg",
                  width: 20,
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Зарегистрирован: ${DateFormat('HH:mm dd.MM.yy').format(DateTime.parse(user.registered))}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Координаты: ${user.latitude}, ${user.longitude}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                IconButton(
                  icon: Icon(Icons.map, size: 20),
                  onPressed: launchMap,
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              children: [
                Text('Друзья', style: Theme.of(context).textTheme.titleLarge),
                for (final friend in user.friends)
                  UserTile(user: friend.getFullUser(context)!),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
