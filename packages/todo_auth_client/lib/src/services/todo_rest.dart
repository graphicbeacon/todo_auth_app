import 'dart:io';

import 'package:dio/dio.dart';
import 'package:todo_auth_client/src/core/core.dart';

class TodoRestService {
  Dio client = Dio(BaseOptions(
    baseUrl: '${TodoAuthAppConstants.serverUrl}/',
    headers: {
      'Content-Type': ContentType.json.mimeType,
    },
  ));

  Future<String> registerAccount({
    required String name,
    required String email,
    required String password,
  }) async {
    client.options.headers.remove('Authorization');
    final response = await client.post('auth/register', data: {
      'name': name,
      'email': email,
      'password': password,
    });
    return response.data['data'];
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    client.options.headers.remove('Authorization');
    final response = await client.post('auth/login', data: {
      'email': email,
      'password': password,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> getAuthenticatedUser(String token) async {
    client.options.headers['Authorization'] = 'Bearer $token';
    final response = await client.get('auth/user');
    return response.data;
  }

  Future<Map<String, dynamic>> createTodo({
    required String title,
    required String token,
    required String? dueDate,
    required String? description,
  }) async {
    client.options.headers['Authorization'] = 'Bearer $token';
    final response = await client.post('todos', data: {
      'title': title,
      'dueDate': dueDate,
      'description': description,
    });
    return response.data;
  }

  Future<List<Map<String, dynamic>>> getTodos(String token) async {
    client.options.headers['Authorization'] = 'Bearer $token';
    final response = await client.get('todos');
    return (response.data as List)
        .map((data) => data as Map<String, dynamic>)
        .toList();
  }

  Future<Map<String, dynamic>> updateTodo({
    required String id,
    required String token,
    String? title,
    String? dueDate,
    String? description,
    bool? isComplete,
  }) async {
    client.options.headers['Authorization'] = 'Bearer $token';
    final response = await client.put('todos/$id', data: {
      'title': title,
      'dueDate': dueDate,
      'description': description,
      'isComplete': isComplete,
    });
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteTodo({
    required String id,
    required String token,
  }) async {
    client.options.headers['Authorization'] = 'Bearer $token';
    final response = await client.delete('todos/$id');
    return response.data;
  }
}
