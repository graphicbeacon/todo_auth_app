import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_auth_client/src/todos/todos.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({required this.data, super.key});

  final Todo data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          left: 14,
          right: 10,
          bottom: 20,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: data.isComplete,
              fillColor: MaterialStateProperty.all(theme.primaryColor),
              onChanged: (value) {},
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(
                    data.title,
                    style: const TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (data.dueDate != null) ...[
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.timer_sharp,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          data.dueDate.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 10),
                  if (data.description != null)
                    Text(
                      data.description!,
                      style: const TextStyle(
                        color: Colors.black38,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(
                Icons.edit,
                color: Colors.deepPurple,
              ),
              onPressed: () {
                context.go('/todos/edit');
              },
            ),
          ],
        ),
      ),
    );
  }
}
