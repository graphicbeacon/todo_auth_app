import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_auth_client/src/auth/auth.dart';
import 'package:todo_auth_client/src/core/core.dart';
import 'package:todo_auth_client/src/todos/todos.dart';
import 'package:todo_auth_client/src/todos/view/todo_list_checkbox.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({
    required this.data,
    required this.deleteInProgress,
    super.key,
  });

  final Todo data;
  final bool deleteInProgress;

  @override
  Widget build(BuildContext context) {
    final isDeleting = context.select<TodosCubit, bool>(
        (b) => deleteInProgress && b.state.itemsToDelete.contains(data.id));

    return Opacity(
      opacity: isDeleting
          ? 0.5
          : data.isComplete
              ? 0.7
              : 1,
      child: Card(
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
              TodoListCheckbox(
                isChecked: data.isComplete,
                isDisabled: deleteInProgress && isDeleting,
                onChanged: (value) {
                  final authState = context.read<AuthCubit>().state;

                  if (authState.token == null) return;

                  context.read<TodosCubit>().updateTodo(
                        token: authState.token!,
                        todo: data.copyWith(isComplete: value ?? false),
                      );
                },
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text(
                      data.title,
                      style: TextStyle(
                        color: data.isComplete
                            ? Colors.blueGrey
                            : Colors.deepPurple,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: data.isComplete
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    if (data.dueDate?.isNotEmpty == true) ...[
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
                      const SizedBox(height: 10),
                    ],
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
                onPressed: deleteInProgress || data.isComplete
                    ? null
                    : () {
                        context.go(
                          TodoAuthAppPaths.editTodo,
                          extra: {'id': data.id},
                        );
                      },
                child: const Icon(
                  Icons.edit,
                  color: Colors.deepPurple,
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: deleteInProgress
                    ? null
                    : () {
                        final authState = context.read<AuthCubit>().state;

                        if (authState.token == null) return;

                        context.read<TodosCubit>().deleteTodo(
                              token: authState.token!,
                              id: data.id,
                            );
                      },
                child: Icon(
                  Icons.delete,
                  color: deleteInProgress
                      ? Colors.blueGrey.shade100
                      : Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
