import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

/// Interface for interacting with database
abstract class TodosDataStore {
  /// Add new user
  void addUser({
    required String name,
    required String email,
    required String password,
    required String salt,
  });

  /// Retrieve user by their email address
  Map<String, dynamic> getUserByEmail(String email);

  /// Retrieve user by their unique id
  Map<String, dynamic> getUserById(String? id);

  /// Get all todos by user
  List<Map<String, dynamic>> getTodos(String userId);

  /// Create new todo for user
  Map<String, dynamic> addTodo({
    required String userId,
    required String title,
    String? dueDate,
    String? description,
  });

  /// Update an existing todo
  Map<String, dynamic>? updateTodo({
    required String userId,
    required String id,
    String? title,
    String? dueDate,
    String? description,
    bool? isComplete,
  });

  /// Remove todo from datastore
  Map<String, dynamic>? deleteTodo({
    required String userId,
    required String id,
  });
}

/// This store uses an in-memory database for the
/// sake of this exercise. In a production scenario
/// this would be replaced with an SQL/NoSQL database
final Map<String, List<Map<String, dynamic>>> _memoryDb = {
  'users': <Map<String, dynamic>>[],
  'todos': <Map<String, dynamic>>[],
};

/// Interface for interacting with _memoryDb store
class InMemoryTodosDataStore implements TodosDataStore {
  ///
  @visibleForTesting
  Map<String, List<Map<String, dynamic>>> get memoryDb => _memoryDb;

  final _uuid = const Uuid();

  @override
  void addUser({
    required String name,
    required String email,
    required String password,
    required String salt,
  }) {
    memoryDb['users']!.add({
      'id': _uuid.v4(),
      'name': name,
      'email': email,
      'password': password,
      'salt': salt,
    });
  }

  @override
  Map<String, dynamic> getUserByEmail(String email) {
    return memoryDb['users']!
        .singleWhere((user) => user['email'] == email, orElse: () => {});
  }

  @override
  Map<String, dynamic> getUserById(String? id) {
    return memoryDb['users']!
        .singleWhere((user) => user['id'] == id, orElse: () => {});
  }

  @override
  List<Map<String, dynamic>> getTodos(String userId) {
    return memoryDb['todos']!
        .where((todo) => todo['userId'] == userId)
        .toList();
  }

  @override
  Map<String, dynamic> addTodo({
    required String userId,
    required String title,
    String? dueDate,
    String? description,
  }) {
    final newTodo = {
      'id': _uuid.v4(),
      'userId': userId,
      'title': title,
      'dueDate': dueDate,
      'description': description,
      'isComplete': false,
    };

    memoryDb['todos']!.add(newTodo);
    return newTodo;
  }

  @override
  Map<String, dynamic>? updateTodo({
    required String userId,
    required String id,
    String? title,
    String? dueDate,
    String? description,
    bool? isComplete,
  }) {
    final todos = memoryDb['todos']!;
    final currTodoIndex = todos.indexWhere(
      (todo) => todo['userId'] == userId && todo['id'] == id,
    );

    if (currTodoIndex == -1) {
      // Todo was not found
      return null;
    }

    final currTodo = todos[currTodoIndex];
    final updatedTodo = {
      'id': currTodo['id'],
      'userId': currTodo['userId'],
      'title': title ?? currTodo['title'],
      'dueDate': dueDate ?? currTodo['dueDate'],
      'description': description ?? currTodo['description'],
      'isComplete': isComplete ?? currTodo['isComplete'],
    };
    todos[currTodoIndex] = updatedTodo;

    return updatedTodo;
  }

  @override
  Map<String, dynamic>? deleteTodo({
    required String userId,
    required String id,
  }) {
    final todos = memoryDb['todos']!;
    final currTodoIndex = todos.indexWhere(
      (todo) => todo['userId'] == userId && todo['id'] == id,
    );

    if (currTodoIndex == -1) {
      // Todo was not found
      return null;
    }

    final deletedTodoId = todos[currTodoIndex]['id'];

    todos.removeAt(currTodoIndex);

    return {'id': deletedTodoId};
  }
}
