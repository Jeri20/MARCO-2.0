import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/profile.dart';
import '../util/todo_tile.dart';
import '../util/dialog_box.dart';
import 'profile_page.dart';
import 'chat_page.dart'; // Import the new chat page
import '../data/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('mybox');
  late Profile profile;
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    super.initState();
    if (_myBox.get('profile') == null) {
      profile =
          Profile(name: 'New User', userClass: 'Unknown', exp: 0, level: 1);
      _myBox.put('profile', profile.toJson());
    } else {
      profile = Profile.fromJson(_myBox.get('profile'));
    }
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
  }

  final _controller = TextEditingController();

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
      if (db.toDoList[index][1]) {
        profile.exp += 5;
        if (profile.exp >= profile.level * 10) {
          profile.level++;
          profile.exp = 0;
          _myBox.put('profile', profile.toJson());
          showLevelUpDialog();
        } else {
          _myBox.put('profile', profile.toJson());
        }
      }
    });
    db.updateDataBase();
  }

  void showLevelUpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Level Up!'),
          content:
              Text('Congratulations! You have reached level ${profile.level}.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  void navigateToChat() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ChatPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 56, 67, 170),
      appBar: AppBar(
        title: Text('TO DO'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => ProfilePage(profile: profile)),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: createNewTask,
            child: Icon(Icons.add),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: navigateToChat,
            child: Icon(Icons.chat),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}
