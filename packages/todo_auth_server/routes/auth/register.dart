import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todo_auth_server/todo_auth_server.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(body: '');
  }

  final payload = await context.request.body();
  final info = json.decode(payload) as Map<String, dynamic>;

  final fields = [info['name'], info['email'], info['password']];
  if (fields.contains(null) || fields.contains('')) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'code': TodoAuthResponseErrorCodes.invalidPayload.value,
        'message': 'Please provide your name, email and password',
      },
    );
  }

  final name = info['name'] as String;
  final email = info['email'] as String;
  final password = info['password'] as String;

  // Ensure user is unique
  final user = context.read<Store>().getUserByEmail(email);
  if (user.isNotEmpty) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'code': TodoAuthResponseErrorCodes.userAlreadyExists.value,
        'message': 'The user already exists',
      },
    );
  }

  // Add user to database
  final salt = generateSalt();
  final hashedPassword = hashPassword(password, salt);
  context.read<Store>().addUser(
        name: name,
        email: email,
        password: hashedPassword,
        salt: salt,
      );

  return Response.json(
    body: {
      'message': 'Registered successfully',
    },
  );
}
