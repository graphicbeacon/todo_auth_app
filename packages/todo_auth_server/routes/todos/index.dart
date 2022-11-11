import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todo_auth_server/todo_auth_server.dart';

Future<Response> onRequest(RequestContext context) async {
  final method = context.request.method;
  final allowedMethods = [HttpMethod.get, HttpMethod.post];

  if (!allowedMethods.contains(method)) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final user = await context.read<Future<TodoAuthUser>>();
  if (user.isEmpty) {
    // verifiedToken was null
    return Response.json(
      statusCode: HttpStatus.unauthorized,
      body: {
        'code': TodoAuthResponseErrorCodes.unauthorised.value,
        'message': 'Unauthorised',
      },
    );
  }

  if (method == HttpMethod.get) {
    return _get(context, user);
  }

  if (method == HttpMethod.post) {
    return _post(context, user);
  }

  return Response(statusCode: HttpStatus.methodNotAllowed);
}

Response _get(RequestContext context, TodoAuthUser user) {
  final todos = context.read<InMemoryTodosDataStore>().getTodos(user.id);
  return Response.json(body: todos);
}

Future<Response> _post(RequestContext context, TodoAuthUser user) async {
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

  final dueDate = data['dueDate'];
  final description = data['description'];

  final createdTodo = context.read<InMemoryTodosDataStore>().addTodo(
        userId: user.id,
        title: title as String,
        dueDate: dueDate as String?,
        description: description as String?,
      );

  // All good
  return Response.json(body: createdTodo);
}
