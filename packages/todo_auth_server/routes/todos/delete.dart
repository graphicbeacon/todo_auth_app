import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todo_auth_server/todo_auth_server.dart';

Future<Response> onRequest(RequestContext context) async {
  final payload = await context.request.body();
  final info = json.decode(payload) as Map<String, dynamic>;

  // Validate payload data
  if (['', null].contains(info['id'])) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'code': TodoAuthResponseErrorCodes.invalidPayload.value,
        'message': 'Please provide todo id',
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

  final deletedTodo = context.read<Store>().deleteTodo(
        userId: userId,
        id: id as String,
      );

  if (deletedTodo == null) {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: {
        'code': TodoAuthResponseErrorCodes.notFound.value,
        'message': 'Not Found',
      },
    );
  }

  return Response.json(body: deletedTodo);
}
