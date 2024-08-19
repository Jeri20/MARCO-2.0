import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'home_page.dart';
import 'setup_page.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _navigateToNextPage(context);
    return Scaffold(
      body: Center(
        child: Text(
          'MARCO',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> _navigateToNextPage(BuildContext context) async {
    await Future.delayed(Duration(seconds: 2));
    final box = Hive.box('mybox');
    final profileExists = box.get('profile') != null;
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => profileExists ? HomePage() : SetupPage(),
    ));
  }
}
