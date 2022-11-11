import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todo_auth_server/todo_auth_server.dart';

// Handle put and delete requests
FutureOr<Response> onRequest(RequestContext context, String id) async {
  final method = context.request.method;
  final allowedMethods = [HttpMethod.delete, HttpMethod.put];

  if (!allowedMethods.contains(method)) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
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

  if (method == HttpMethod.delete) {
    return _delete(context, user, id);
  }

  if (method == HttpMethod.put) {
    return await _put(context, user, id);
  }

  return Response(statusCode: HttpStatus.methodNotAllowed);
}

Response _delete(
  RequestContext context,
  TodoAuthUser user,
  String id,
) {
  final deletedTodo = context.read<InMemoryTodosDataStore>().deleteTodo(
        userId: user.id,
        id: id,
      );

  // Resource does not exist
  if (deletedTodo == null) {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: {
        'code': TodoAuthResponseErrorCodes.notFound.value,
        'message': 'Not Found',
      },
    );
  }

  // All good
  return Response.json(body: deletedTodo);
}

Future<Response> _put(
  RequestContext context,
  TodoAuthUser user,
  String id,
) async {
  final payload = await context.request.body();
  final data = json.decode(payload) as Map<String, dynamic>;
  final title = data['title'];

  // Validate payload data
  if (['', null].contains(title)) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'code': TodoAuthResponseErrorCodes.invalidPayload.value,
        'message': 'Please provide required data',
      },
    );
  }

  final updatedTodo = context.read<InMemoryTodosDataStore>().updateTodo(
        userId: user.id,
        id: id,
        title: title as String,
        dueDate: data['dueDate'] as String?,
        description: data['description'] as String?,
        isComplete: data['isComplete'] as bool?,
      );

  // Resource does not exist
  if (updatedTodo == null) {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: {
        'code': TodoAuthResponseErrorCodes.notFound.value,
        'message': 'Not Found',
      },
    );
  }

  // All good
  return Response.json(body: updatedTodo);
}
