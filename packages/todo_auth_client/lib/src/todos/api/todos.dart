import 'package:todo_auth_client/src/services/services.dart';
import 'package:todo_auth_client/src/todos/todos.dart';

class TodosApi {
  const TodosApi(this.service);

  final TodoRestService service;

  Future<Todo> create(Todo todo) {
    return Future.value(todo);
  }

  Future<List<Todo>> read() {
    return Future.value([]);
  }

  Future<Todo> update(Todo todo) {
    return Future.value(todo);
  }

  Future<Todo> delete(Todo todo) {
    return Future.value(todo);
  }
}
