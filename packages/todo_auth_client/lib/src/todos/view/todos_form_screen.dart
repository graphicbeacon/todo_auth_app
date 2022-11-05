import 'package:flutter/material.dart';
import 'package:todo_auth_client/src/todos/todos.dart';

class TodosFormScreen extends StatelessWidget {
  const TodosFormScreen({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SizedBox(
            width: 400,
            child: Column(
              children: const [TodosForm()],
            ),
          ),
        ),
      ),
    );
  }
}
