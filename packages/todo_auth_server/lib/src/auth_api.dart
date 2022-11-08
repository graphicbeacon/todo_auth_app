import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class AuthApi {
  AuthApi();

  Router get router {
    final router = Router();

    router.post('/register', (Request req) async {
      final payload = await req.readAsString();
      final info = payload.isNotEmpty ? json.decode(payload) : {};
      final name = info['name'];
      final email = info['email'];
      final password = info['password'];

      // Validate payload information
      if ([name, email, password].contains(null) ||
          [name, email, password].contains('')) {
        return Response.badRequest(
            body: 'Please provide your name, email and password');
      }

      // TODO: Create user

      return Response.ok('Registered');
    });

    router.post('/login', (Request req) async {
      return Response.ok('Logged in');
    });

    return router;
  }
}
