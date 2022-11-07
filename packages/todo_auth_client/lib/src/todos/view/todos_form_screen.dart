import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_auth_client/src/todos/todos.dart';

class TodosFormScreen extends StatelessWidget {
  const TodosFormScreen({required this.title, this.editId, super.key});

  final String title;
  final String? editId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final todo = context.select<TodosCubit, Todo?>((b) {
      try {
        return b.state.todos.singleWhere((todo) => todo.id == editId);
      } catch (_) {
        return null;
      }
    });

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
              children: [TodosForm(data: todo)],
            ),
          ),
        ),
      ),
    );
  }
}
