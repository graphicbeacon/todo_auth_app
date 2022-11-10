import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:todo_auth_server/todo_auth_server.dart';

/// Verify JWT and retrieve user object
Middleware asyncUserProvider() {
  return provider<Future<TodoAuthUser>>((context) async {
    final payload = await context.request.body();

    if (payload.isEmpty) {
      return TodoAuthUser.empty();
    }

    try {
      final info = json.decode(payload) as Map<String, dynamic>;
      final token = info['token'];
      final verifiedToken = JWT.verify(
        token as String,
        SecretKey(TodoAuthServerConstants.jwtSecretKey),
      );
      final user = context.read<Store>().getUserById(verifiedToken.subject);

      if (user.isEmpty) {
        throw Exception('Empty user');
      }

      return TodoAuthUser(
        id: user['id'] as String,
        name: user['name'] as String,
        email: user['email'] as String,
      );
    } catch (_) {}

    return TodoAuthUser.empty();
  });
}
