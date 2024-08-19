import 'package:flutter/material.dart';
import '../models/profile.dart';

class ProfilePage extends StatelessWidget {
  final Profile profile;

  const ProfilePage({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Name: ${profile.name}', style: TextStyle(fontSize: 20)),
            Text('Class: ${profile.userClass}', style: TextStyle(fontSize: 20)),
            Text('EXP: ${profile.exp}', style: TextStyle(fontSize: 20)),
            Text('Level: ${profile.level}', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
