import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:todo_auth_server/todo_auth_server.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(body: '');
  }

  final payload = await context.request.body();
  final info = json.decode(payload) as Map<String, dynamic>;
  final token = info['token'];

  // Validate payload data
  if (['', null].contains(token)) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'code': TodoAuthResponseErrorCodes.invalidPayload.value,
        'message': 'Please provide a valid token',
      },
    );
  }

  try {
    final verifiedToken = JWT.verify(
      token as String,
      SecretKey(TodoAuthServerConstants.jwtSecretKey),
    );
    final user = context.read<Store>().getUserById(verifiedToken.subject);
    final todos = context
        .read<Store>()
        .getTodos(user['id'] as String); // throws if user id is null

    return Response.json(body: {'message': todos});
  } catch (_) {
    return Response.json(
      statusCode: HttpStatus.unauthorized,
      body: {
        'code': TodoAuthResponseErrorCodes.unauthorised.value,
        'message': 'Unauthorised',
      },
    );
  }
}
