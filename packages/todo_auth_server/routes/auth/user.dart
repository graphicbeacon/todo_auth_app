import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todo_auth_server/todo_auth_server.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(body: '');
  }

  final user = context.read<TodoAuthUser?>();
  if (user == null) {
    // User does not exist or jwt is invalid
    return Response.json(
      statusCode: HttpStatus.unauthorized,
      body: {
        'code': TodoAuthResponseErrorCodes.unauthorised.value,
        'message': 'Unauthorised',
      },
    );
  }

  // All good
  return Response.json(body: {'message': user.name});
}
