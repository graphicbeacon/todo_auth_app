import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todo_auth_server/todo_auth_server.dart';

Future<Response> onRequest(RequestContext context) async {
  final payload = await context.request.body();
  final info = json.decode(payload) as Map<String, dynamic>;
  final fields = [info['id'], info['title']];

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

  final user = context.read<TodoAuthUser?>();

  if (user == null) {
    return Response.json(
      statusCode: HttpStatus.unauthorized,
      body: {
        'code': TodoAuthResponseErrorCodes.unauthorised.value,
        'message': 'Unauthorised',
      },
    );
  }

  final userId = user.id;
  final id = info['id'];
  final title = info['title'];
  final dueDate = info['dueDate'];
  final description = info['description'];
  final isComplete = info['isComplete'];

  final updatedTodo = context.read<Store>().updateTodo(
        userId: userId,
        id: id as String,
        title: title as String,
        dueDate: dueDate as String?,
        description: description as String?,
        isComplete: isComplete as bool?,
      );

  return Response.json(body: updatedTodo ?? {});
}
