import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:todo_auth_server/todo_auth_server.dart';

/// Retrieve user object from jwt
Middleware asyncUserProvider() {
  return provider<Future<TodoAuthUser>>((context) async {
    final authHeader = context.request.headers['Authorization'];

    if (authHeader == null) {
      return TodoAuthUser.empty();
    }

    try {
      final bearer = authHeader.replaceAll('Bearer ', '');
      final verifiedToken = JWT.verify(
        bearer,
        SecretKey(TodoAuthServerConstants.jwtSecretKey),
      );
      final user = context
          .read<InMemoryTodosDataStore>()
          .getUserById(verifiedToken.subject);

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

/// Verify JWT
Middleware verifyJwtToken() => (handler) => (context) async {
      final authHeader = context.request.headers['Authorization'];

      if (authHeader == null) {
        return Response.json(
          statusCode: HttpStatus.forbidden,
          body: {
            'code': TodoAuthResponseErrorCodes.invalidCredentials.value,
            'message': 'Missing authorization header',
          },
        );
      }

      try {
        final bearer = authHeader.replaceAll('Bearer ', '');
        JWT.verify(
          bearer,
          SecretKey(TodoAuthServerConstants.jwtSecretKey),
        );
      } catch (error) {
        return Response.json(
          statusCode: HttpStatus.forbidden,
          body: {
            'code': TodoAuthResponseErrorCodes.invalidJwt.value,
            'message': 'Please provide a valid jwt',
          },
        );
      }

      // Pass the request along
      return await handler(context);
    };
