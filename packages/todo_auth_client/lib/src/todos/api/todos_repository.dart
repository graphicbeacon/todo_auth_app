import 'package:todo_auth_client/src/services/services.dart';
import 'package:todo_auth_client/src/todos/todos.dart';

class TodosRepository {
  const TodosRepository(this.service);

  final TodoRestService service;

  Future<List<Todo>> getTodos(String token) {
    return Future.value(const [
      Todo(
        id: '1',
        title: 'Todo title 1',
        isComplete: false,
        description: 'Todo description',
        dueDate: '2022-11-11',
      ),
      Todo(
        id: '2',
        title: 'Todo title 2',
        isComplete: true,
        description: 'Todo description',
        dueDate: '2022-11-13',
      ),
    ]);
  }

  Future<Todo> createTodo({
    required String token,
    required String title,
    String? dueDate,
    String? description,
  }) {
    return Future.value(
      Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        dueDate: dueDate,
        description: description,
        isComplete: false,
      ),
    );
  }

  Future<Todo> updateTodo({
    required String token,
    required Todo todo,
  }) {
    return Future.value(todo);
  }

  Future<String> deleteTodo({
    required String token,
    required String id,
  }) {
    return Future.value(id);
  }
}
