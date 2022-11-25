import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_auth_client/src/core/core.dart';

class NoTodosFound extends StatelessWidget {
  const NoTodosFound({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        const SizedBox(height: 30),
        const Icon(
          Icons.note_alt,
          color: Colors.black12,
          size: 68,
        ),
        const SizedBox(height: 4),
        const Text(
          'No todos found',
          style: TextStyle(
            color: Colors.black26,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 14),
        CupertinoButton(
          onPressed: () {
            context.go(TodoAuthAppPaths.newTodo);
          },
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          color: theme.primaryColor,
          child: const Text('Add new'),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
