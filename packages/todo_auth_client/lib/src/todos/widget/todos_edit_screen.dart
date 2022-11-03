import 'package:flutter/material.dart';
import 'package:todo_auth_client/src/todos/todos.dart';

class TodosEditScreen extends StatelessWidget {
  const TodosEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: AppBar(
        title: const Text('Edit Todo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [TodosForm()],
        ),
      ),
    );
  }
}
