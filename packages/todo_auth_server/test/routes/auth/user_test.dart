import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:todo_auth_server/todo_auth_server.dart';

import '../../../routes/auth/user.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('/auth/user', () {
    test('POST responds with a 200 and user details', () async {
      final context = _MockRequestContext();
      final store = Store()
        ..memoryDb['users']!.add({
          'id': '645dd7c5-dc1d-4b2d-9729-0174d3d08e91',
          'name': 'Johnny',
          'email': 'johnny@todo.com',
          'password':
              '0083b3ecada67c5d9608ca9aab4a9cbf19f7ca453fa56e3789320d0013feb7a0',
          'salt': 'JISxNzVFqP0ensZHYIVboSZNWt6npZSm5ZqCmc/xiXU=',
          'isComplete': false,
        });
      final token = generateJwt(
        subject: '645dd7c5-dc1d-4b2d-9729-0174d3d08e91',
        issuer: TodoAuthServerConstants.jwtIssuer,
        secret: TodoAuthServerConstants.jwtSecretKey,
      );
      final request = Request.post(
        Uri.parse('http://localhost/auth/user'),
        body: json.encode({'token': token}),
      );
      when(() => context.request).thenReturn(request);
      when(() => context.read<Store>()).thenReturn(store);

      final response = await route.onRequest(context);
      final body = await response.body();
      final decodedBody = json.decode(body) as Map<String, dynamic>;

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(decodedBody['message'], equals('Johnny'));
    });

    test('POST responds with a 401 if invalid payload', () async {
      final context = _MockRequestContext();
      final store = Store();
      final request = Request.post(
        Uri.parse('http://localhost/auth/user'),
        body: json.encode({'token': ''}),
      );
      when(() => context.request).thenReturn(request);
      when(() => context.read<Store>()).thenReturn(store);

      final response = await route.onRequest(context);
      final body = await response.body();
      final decodedBody = json.decode(body) as Map<String, dynamic>;

      expect(response.statusCode, equals(HttpStatus.badRequest));
      expect(decodedBody['code'], equals('INVALID_PAYLOAD'));
      expect(decodedBody['message'], equals('Please provide a valid token'));
    });

    test('POST responds with a 401 if jwt is invalid', () async {
      final context = _MockRequestContext();
      final store = Store();
      final request = Request.post(
        Uri.parse('http://localhost/auth/user'),
        body: json.encode({'token': 'invalid jwt'}),
      );
      when(() => context.request).thenReturn(request);
      when(() => context.read<Store>()).thenReturn(store);

      final response = await route.onRequest(context);
      final body = await response.body();
      final decodedBody = json.decode(body) as Map<String, dynamic>;

      expect(response.statusCode, equals(HttpStatus.unauthorized));
      expect(decodedBody['code'], equals('UNAUTHORISED'));
      expect(decodedBody['message'], equals('Unauthorised'));
    });

    test('POST responds with a 401 if user does not exist', () async {
      final context = _MockRequestContext();
      final store = Store();
      final token = generateJwt(
        subject: 'does not exist',
        issuer: TodoAuthServerConstants.jwtIssuer,
        secret: TodoAuthServerConstants.jwtSecretKey,
      );
      final request = Request.post(
        Uri.parse('http://localhost/auth/user'),
        body: json.encode({'token': token}),
      );
      when(() => context.request).thenReturn(request);
      when(() => context.read<Store>()).thenReturn(store);

      final response = await route.onRequest(context);
      final body = await response.body();
      final decodedBody = json.decode(body) as Map<String, dynamic>;

      expect(response.statusCode, equals(HttpStatus.unauthorized));
      expect(decodedBody['code'], equals('UNAUTHORISED'));
      expect(decodedBody['message'], equals('Unauthorised'));
    });

    test('other than POST responds with empty string', () async {
      final context = _MockRequestContext();
      final request = Request.get(Uri.parse('http://localhost/auth/user'));
      when(() => context.request).thenReturn(request);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(
        response.body(),
        completion(equals('')),
      );
    });
  });
}
