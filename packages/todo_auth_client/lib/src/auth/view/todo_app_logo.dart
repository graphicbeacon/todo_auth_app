import 'package:flutter/material.dart';

class TodoAppLogo extends StatelessWidget {
  const TodoAppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 30,
          child: Icon(
            Icons.app_registration_rounded,
            color: Colors.deepPurple,
            size: 40,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Todo App',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ],
    );
  }
}
