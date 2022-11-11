import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todo_auth_server/todo_auth_server.dart';

Future<Response> onRequest(RequestContext context) async {
  final payload = await context.request.body();
  final info = json.decode(payload) as Map<String, dynamic>;

  // Validate payload data
  if (['', null].contains(info['title'])) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'code': TodoAuthResponseErrorCodes.invalidPayload.value,
        'message': 'Please provide required data',
      },
    );
  }

  final user = await context.read<Future<TodoAuthUser>>();

  if (user.isEmpty) {
    return Response.json(
      statusCode: HttpStatus.unauthorized,
      body: {
        'code': TodoAuthResponseErrorCodes.unauthorised.value,
        'message': 'Unauthorised',
      },
    );
  }

  final userId = user.id;
  final title = info['title'];
  final dueDate = info['dueDate'];
  final description = info['description'];

  final createdTodo = context.read<InMemoryTodosDataStore>().addTodo(
        userId: userId,
        title: title as String,
        dueDate: dueDate as String?,
        description: description as String?,
      );

  return Response.json(body: {'data': createdTodo});
}
