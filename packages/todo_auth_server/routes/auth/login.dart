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

  final fields = [info['email'], info['password']];
  if (fields.contains(null) || fields.contains('')) {
    return Response.json(
      statusCode: HttpStatus.forbidden,
      body: {
        'code': TodoAuthResponseErrorCodes.invalidPayload.value,
        'message': 'Please provide your user and/or password',
      },
    );
  }

  final email = info['email'] as String;
  final password = info['password'] as String;

  // Get user and validate
  final user = context.read<Store>().getUserByEmail(email);

  if (user.isEmpty) {
    return Response.json(
      statusCode: HttpStatus.forbidden,
      body: {
        'code': TodoAuthResponseErrorCodes.invalidCredentials.value,
        'message': 'Incorrect user and/or password',
      },
    );
  }

  // Validate password
  final hashedPassword = hashPassword(password, user['salt'] as String);
  if (hashedPassword != user['password']) {
    return Response.json(
      statusCode: HttpStatus.forbidden,
      body: {
        'code': TodoAuthResponseErrorCodes.invalidCredentials.value,
        'message': 'Incorrect user and/or password',
      },
    );
  }

  final token = generateJwt(
    subject: user['id'] as String,
    issuer: TodoAuthServerConstants.jwtIssuer,
    secret: TodoAuthServerConstants.jwtSecretKey,
  );

  return Response.json(body: {'data': token});
}
