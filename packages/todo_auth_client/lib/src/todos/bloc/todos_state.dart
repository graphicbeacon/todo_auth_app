import 'package:equatable/equatable.dart';
import 'package:todo_auth_client/src/todos/todos.dart';

class TodosState extends Equatable {
  const TodosState({
    this.status = TodosRequest.unknown,
    this.formStatus = TodosRequest.unknown,
    this.deleteItemStatus = TodosRequest.unknown,
    this.itemsToDelete = const {},
    this.todos = const [],
  });

  final TodosRequest status;
  final TodosRequest formStatus;
  final TodosRequest deleteItemStatus;
  final Set<String> itemsToDelete;
  final List<Todo> todos;

  TodosState copyWith({
    TodosRequest? status,
    TodosRequest? formStatus,
    TodosRequest? deleteItemStatus,
    Set<String>? itemsToDelete,
    List<Todo>? todos,
  }) =>
      TodosState(
        status: status ?? this.status,
        formStatus: formStatus ?? this.formStatus,
        deleteItemStatus: deleteItemStatus ?? this.deleteItemStatus,
        itemsToDelete: itemsToDelete ?? this.itemsToDelete,
        todos: todos ?? this.todos,
      );

  @override
  List<Object?> get props => [
        status,
        formStatus,
        deleteItemStatus,
        itemsToDelete,
        todos,
      ];
}

enum TodosRequest {
  requestFailure,
  requestInProgress,
  requestSuccess,
  unknown,
}
