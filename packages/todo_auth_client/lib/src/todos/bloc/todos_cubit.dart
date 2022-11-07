import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_auth_client/src/todos/todos.dart';

class TodosCubit extends Cubit<TodosState> {
  TodosCubit(this.repository, super.initialState);

  final TodosRepository repository;

  getTodos(String token) async {
    try {
      emit(state.copyWith(status: TodosRequest.requestInProgress));

      final todos = await repository.getTodos(token);

      emit(state.copyWith(status: TodosRequest.requestSuccess, todos: todos));
    } catch (_) {
      emit(state.copyWith(status: TodosRequest.requestFailure));
    }
  }

  createTodo({
    required String token,
    required String title,
    String? dueDate,
    String? description,
  }) async {
    try {
      emit(state.copyWith(formStatus: TodosRequest.requestInProgress));

      final newTodo = await repository.createTodo(
        token: token,
        title: title,
        dueDate: dueDate,
        description: description,
      );

      emit(
        state.copyWith(
          formStatus: TodosRequest.requestSuccess,
          todos: [...state.todos, newTodo],
        ),
      );
    } catch (_) {
      emit(state.copyWith(formStatus: TodosRequest.requestFailure));
    }
  }

  updateTodo({
    required String token,
    required Todo todo,
  }) async {
    try {
      emit(state.copyWith(formStatus: TodosRequest.requestInProgress));

      await repository.updateTodo(
        token: token,
        todo: todo,
      );

      final updatedTodoIndex = state.todos.indexWhere((t) => t.id == todo.id);
      final todos = [...state.todos]..replaceRange(
          updatedTodoIndex,
          updatedTodoIndex + 1,
          [todo],
        );

      emit(
        state.copyWith(
          formStatus: TodosRequest.requestSuccess,
          todos: todos,
        ),
      );
    } catch (_) {
      emit(state.copyWith(formStatus: TodosRequest.requestFailure));
    }
  }

  deleteTodo({
    required String token,
    required String id,
  }) async {
    try {
      emit(state.copyWith(
        deleteItemStatus: TodosRequest.requestInProgress,
        itemsToDelete: {...state.itemsToDelete, id},
      ));

      await repository.deleteTodo(token: token, id: id);

      emit(state.copyWith(
        deleteItemStatus: TodosRequest.requestSuccess,
        itemsToDelete: {...state.itemsToDelete}..remove(id),
        todos: [...state.todos]..removeWhere((todo) => todo.id == id),
      ));
    } catch (_) {
      emit(state.copyWith(
        deleteItemStatus: TodosRequest.requestFailure,
        itemsToDelete: {...state.itemsToDelete}..remove(id),
      ));
    }
  }
}
