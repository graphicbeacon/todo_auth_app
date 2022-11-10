import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:todo_auth_server/todo_auth_server.dart';

Future<Response> onRequest(RequestContext context) async {
  final payload = await context.request.body();
  final info = json.decode(payload) as Map<String, dynamic>;
  final fields = [info['token'], info['title']];

  // Validate payload data
  if (fields.contains('') || fields.contains(null)) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'code': TodoAuthResponseErrorCodes.invalidPayload.value,
        'message': 'Please provide required data',
      },
    );
  }

  final verifiedToken = JWT.verify(
    info['token'] as String,
    SecretKey(TodoAuthServerConstants.jwtSecretKey),
  );
  final user = context.read<Store>().getUserById(verifiedToken.subject);

  final userId = user['id'];
  final title = info['title'];
  final dueDate = info['dueDate'];
  final description = info['description'];

  final createdTodo = context.read<Store>().addTodo(
        userId: userId as String,
        title: title as String,
        dueDate: dueDate as String?,
        description: description as String?,
      );

  return Response.json(body: createdTodo);
}
