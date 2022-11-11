import 'package:todo_auth_client/src/services/services.dart';
import 'package:todo_auth_client/src/todos/todos.dart';

class TodosRepository {
  const TodosRepository(this.service);

  final TodoRestService service;

  Future<List<Todo>> getTodos(String token) async {
    final response = await service.getTodos(token);
    return response.map((todo) => Todo.fromJson(todo)).toList();
  }

  Future<Todo> createTodo({
    required String token,
    required String title,
    String? dueDate,
    String? description,
  }) async {
    final response = await service.createTodo(
      title: title,
      token: token,
      dueDate: dueDate,
      description: description,
    );
    return Todo.fromJson(response);
  }

  Future<Todo> updateTodo({
    required String token,
    required Todo todo,
  }) async {
    final response = await service.updateTodo(
      id: todo.id,
      token: token,
      title: todo.title,
      dueDate: todo.dueDate,
      description: todo.description,
      isComplete: todo.isComplete,
    );
    return Todo.fromJson(response);
  }

  Future<String> deleteTodo({
    required String token,
    required String id,
  }) async {
    final response = await service.deleteTodo(
      id: id,
      token: token,
    );
    return response['id']!;
  }
}
