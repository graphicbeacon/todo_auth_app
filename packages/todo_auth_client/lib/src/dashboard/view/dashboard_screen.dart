import 'package:flutter/material.dart';
import 'package:todo_auth_client/src/dashboard/dashboard.dart';
import 'package:todo_auth_client/src/dashboard/view/hello_user.dart';
import 'package:todo_auth_client/src/todos/todos.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        actions: const [
          AddNewAction(),
          SizedBox(width: 20),
          LogoutAction(),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SizedBox(
            width: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                HelloUser(),
                TodosList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
