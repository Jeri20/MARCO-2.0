import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const DialogBox({
    Key? key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: "Add a new task"),
      ),
      actions: [
        TextButton(onPressed: onCancel, child: Text('Cancel')),
        TextButton(onPressed: onSave, child: Text('Save')),
      ],
    );
  }
}
