import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_auth_client/src/core/core.dart';

class AddNewAction extends StatelessWidget {
  const AddNewAction({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(TodoAuthAppPaths.newTodo);
      },
      child: Row(
        children: const [
          Icon(
            Icons.add,
          ),
          SizedBox(width: 4),
          Text(
            'Add new',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 4),
        ],
      ),
    );
  }
}
