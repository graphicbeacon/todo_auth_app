import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todo_auth_server/todo_auth_server.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(body: '');
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

  // All good
  final todos = context.read<Store>().getTodos(user.id);
  return Response.json(body: {'message': todos});
}
