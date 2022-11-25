import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_auth_client/src/auth/auth.dart';
import 'package:todo_auth_client/src/core/helpers.dart';
import 'package:todo_auth_client/src/todos/todos.dart';
import 'package:todo_auth_client/src/todos/view/no_todos_found.dart';
import 'package:todo_auth_client/src/todos/view/todo_list_item.dart';

class TodosList extends StatelessWidget {
  const TodosList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodosCubit, TodosState>(
      listener: (context, state) {
        if (state.deleteItemStatus == TodosRequest.requestFailure) {
          showAlert(context, 'Problem deleting todo. Please try again');
        }

        if (state.formStatus == TodosRequest.requestFailure) {
          showAlert(
            context,
            'Problem changing todo status. Please try again',
          );
        }
      },
      builder: (context, state) {
        final authState = context.read<AuthCubit>().state;
        if (state.status == TodosRequest.unknown && authState.token != null) {
          context.read<TodosCubit>().getTodos(authState.token!);
          return Container();
        }

        if (state.status == TodosRequest.requestInProgress) {
          return const CircularProgressIndicator();
        }

        if (state.status == TodosRequest.requestFailure) {
          return const Text('Request failed');
        }

        if (state.todos.isEmpty) {
          return const Center(child: NoTodosFound());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: state.todos
              .map(
                (todo) => TodoListItem(
                  key: ValueKey(todo.id),
                  data: todo,
                  deleteInProgress:
                      state.deleteItemStatus == TodosRequest.requestInProgress,
                ),
              )
              .toList(),
        );
      },
    );
  }
}
