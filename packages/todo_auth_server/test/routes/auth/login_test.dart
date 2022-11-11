import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:todo_auth_server/todo_auth_server.dart';

import '../../../routes/auth/login.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('/auth/login', () {
    late InMemoryTodosDataStore store;

    setUp(() {
      store = InMemoryTodosDataStore()
        ..memoryDb['users']!.add({
          'id': '645dd7c5-dc1d-4b2d-9729-0174d3d08e91',
          'name': 'Johnny',
          'email': 'johnny@todo.com',
          'password':
              '0083b3ecada67c5d9608ca9aab4a9cbf19f7ca453fa56e3789320d0013feb7a0',
          'salt': 'JISxNzVFqP0ensZHYIVboSZNWt6npZSm5ZqCmc/xiXU=',
        });
    });

    tearDown(() {
      store.memoryDb['users']!.clear();
    });

    test('POST responds with a 200 and jwt token', () async {
      final context = _MockRequestContext();
      final request = Request.post(
        Uri.parse('http://localhost/auth/login'),
        body: json.encode({
          'email': 'johnny@todo.com',
          'password': 'password123',
        }),
      );
      when(() => context.request).thenReturn(request);
      when(() => context.read<InMemoryTodosDataStore>()).thenReturn(store);

      final response = await route.onRequest(context);
      final body = await response.body();
      final decodedBody = json.decode(body) as Map<String, dynamic>;

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(decodedBody['data'], matches(RegExp('.+')));
    });

    test('POST responds with a 401 if invalid payload', () async {
      final context = _MockRequestContext();
      final request = Request.post(
        Uri.parse('http://localhost/auth/login'),
        body: json.encode({
          'email': '',
          'password': null,
        }),
      );
      when(() => context.request).thenReturn(request);
      when(() => context.read<InMemoryTodosDataStore>()).thenReturn(store);

      final response = await route.onRequest(context);
      final body = await response.body();
      final decodedBody = json.decode(body) as Map<String, dynamic>;

      expect(response.statusCode, equals(HttpStatus.forbidden));
      expect(decodedBody['code'], equals('INVALID_PAYLOAD'));
      expect(
        decodedBody['message'],
        equals('Please provide your user and/or password'),
      );
    });

    test('POST responds with a 401 if user does not exist', () async {
      final context = _MockRequestContext();
      final request = Request.post(
        Uri.parse('http://localhost/auth/login'),
        body: json.encode({
          'email': 'robot@todo.com',
          'password': 'password123',
        }),
      );
      when(() => context.request).thenReturn(request);
      when(() => context.read<InMemoryTodosDataStore>()).thenReturn(store);

      final response = await route.onRequest(context);
      final body = await response.body();
      final decodedBody = json.decode(body) as Map<String, dynamic>;

      expect(response.statusCode, equals(HttpStatus.forbidden));
      expect(decodedBody['code'], equals('INVALID_CREDENTIALS'));
      expect(
        decodedBody['message'],
        equals('Incorrect user and/or password'),
      );
    });

    test('POST responds with a 401 if password is incorrect', () async {
      final context = _MockRequestContext();
      final request = Request.post(
        Uri.parse('http://localhost/auth/login'),
        body: json.encode({
          'email': 'johnny@todo.com',
          'password': 'wrongpassword',
        }),
      );
      when(() => context.request).thenReturn(request);
      when(() => context.read<InMemoryTodosDataStore>()).thenReturn(store);

      final response = await route.onRequest(context);
      final body = await response.body();
      final decodedBody = json.decode(body) as Map<String, dynamic>;

      expect(response.statusCode, equals(HttpStatus.forbidden));
      expect(decodedBody['code'], equals('INVALID_CREDENTIALS'));
      expect(
        decodedBody['message'],
        equals('Incorrect user and/or password'),
      );
    });

    test('other than POST responds with empty string', () async {
      final context = _MockRequestContext();
      final request = Request.get(Uri.parse('http://localhost/auth/login'));
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
