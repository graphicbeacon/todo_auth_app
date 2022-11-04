import 'package:flutter/material.dart';
import 'package:todo_auth_client/src/todos/todos.dart';
import 'package:todo_auth_client/src/todos/widget/add_new_action.dart';
import 'package:todo_auth_client/src/todos/widget/log_out_action.dart';
import 'package:todo_auth_client/src/todos/widget/todo_list_item.dart';

class TodosScreen extends StatelessWidget {
  const TodosScreen({super.key});

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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TodoListItem(
                  data: Todo(
                    id: '1',
                    title: 'Go to the store',
                    dueDate: DateTime.now(),
                    description: 'Lorem ipsum dolor sit amet consectetur',
                  ),
                ),
                TodoListItem(
                  data: Todo(
                    id: '2',
                    title: 'Go to the store',
                    isComplete: true,
                    dueDate: DateTime.now(),
                    description: 'Lorem ipsum dolor sit amet consectetur',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
