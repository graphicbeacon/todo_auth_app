import 'package:meta/meta.dart';
import 'package:todo_auth_server/todo_auth_server.dart';
import 'package:uuid/uuid.dart';

/// This store uses an in-memory database for the
/// sake of this exercise. In a production scenario
/// this would connect to an actual database
class Store {
  ///
  @visibleForTesting
  final Map<String, List<Map<String, dynamic>>> memoryDb = {
    'users': <Map<String, dynamic>>[],
    'todos': <Map<String, dynamic>>[],
  };

  final _uuid = const Uuid();

  ///
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
      'isComplete': false,
    });
  }

  ///
  Map<String, dynamic> getUserByEmail(String email) {
    return memoryDb['users']!
        .singleWhere((user) => user['email'] == email, orElse: () => {});
  }

  ///
  Map<String, dynamic> getUserById(String? id) {
    return memoryDb['users']!
        .singleWhere((user) => user['id'] == id, orElse: () => {});
  }

  ///
  List<Map<String, dynamic>> getTodos(String userId) {
    return memoryDb['todos']!
        .where((todo) => todo['userId'] == userId)
        .toList();
  }

  ///
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
}