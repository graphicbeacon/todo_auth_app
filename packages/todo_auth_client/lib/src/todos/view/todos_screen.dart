import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_auth_client/src/auth/auth.dart';
import 'package:todo_auth_client/src/todos/todos.dart';
import 'package:todo_auth_client/src/todos/view/add_new_action.dart';
import 'package:todo_auth_client/src/todos/view/log_out_action.dart';
import 'package:todo_auth_client/src/todos/view/no_todos_found.dart';
import 'package:todo_auth_client/src/todos/view/todo_list_item.dart';

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
            child: BlocBuilder<TodosCubit, TodosState>(
              builder: (context, state) {
                final authState = context.read<AuthCubit>().state;
                if (state.status == TodosRequest.unknown &&
                    authState.token != null) {
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
                  return const NoTodosFound();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: state.todos
                      .map((todo) => TodoListItem(
                            key: ValueKey(todo.id),
                            data: todo,
                          ))
                      .toList(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
