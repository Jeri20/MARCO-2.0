import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/profile.dart';
import 'home_page.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({Key? key}) : super(key: key);

  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final _nameController = TextEditingController();
  String? _selectedClass;
  final List<String> _classes = ['Fighter', 'Assassin', 'Spy'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Setup Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: _selectedClass,
              hint: Text('Select Class'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedClass = newValue;
                });
              },
              items: _classes.map((String className) {
                return DropdownMenuItem<String>(
                  value: className,
                  child: Text(className),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile() {
    if (_nameController.text.isEmpty || _selectedClass == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter your name and select a class'),
      ));
      return;
    }

    final newProfile = Profile(
      name: _nameController.text,
      userClass: _selectedClass!,
      level: 1,
      exp: 0,
    );

    final box = Hive.box('mybox');
    box.put('profile', newProfile.toJson());

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => HomePage()),
    );
  }
}
