import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:todo_auth_server/todo_auth_server.dart';

import '../../../routes/auth/register.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('/auth/register', () {
    late Store store;

    setUp(() {
      store = Store();
    });

    tearDown(() {
      store.memoryDb['users']!.clear();
    });

    test('POST responds with a 200 and message', () async {
      final context = _MockRequestContext();
      final request = Request.post(
        Uri.parse('http://localhost/auth/register'),
        body: json.encode({
          'name': 'Johnny',
          'email': 'johnny@todo.com',
          'password': 'password123',
        }),
      );
      when(() => context.request).thenReturn(request);
      when(() => context.read<Store>()).thenReturn(store);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(store.memoryDb['users']![0], isMap);
      expect(store.memoryDb['users']![0]['id'], matches(RegExp('.+')));
      expect(store.memoryDb['users']![0]['name'], equals('Johnny'));
      expect(store.memoryDb['users']![0]['email'], equals('johnny@todo.com'));
      expect(store.memoryDb['users']![0]['salt'], matches(RegExp('.+')));
      expect(store.memoryDb['users']![0]['password'], matches(RegExp('.+')));
      expect(
        response.body(),
        completion(equals(json.encode({'data': 'Registered successfully'}))),
      );
    });

    test('POST responds with 400 and code/message if invalid payload',
        () async {
      final context = _MockRequestContext();
      final request = Request.post(
        Uri.parse('http://localhost/auth/register'),
        body: json.encode({
          'name': '',
          'email': '',
          'password': null,
        }),
      );
      when(() => context.request).thenReturn(request);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      expect(
        response.body(),
        completion(
          equals(
            json.encode({
              'code': 'INVALID_PAYLOAD',
              'message': 'Please provide your name, email and password',
            }),
          ),
        ),
      );
    });

    test('POST responds with 400 and code/message if user already exists',
        () async {
      final context = _MockRequestContext();
      final request = Request.post(
        Uri.parse('http://localhost/auth/register'),
        body: json.encode({
          'name': 'Johnny',
          'email': 'johnny@todo.com',
          'password': 'password123',
        }),
      );
      when(() => context.request).thenReturn(request);

      store.memoryDb['users']!.add({'email': 'johnny@todo.com'});
      when(() => context.read<Store>()).thenReturn(store);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      expect(
        response.body(),
        completion(
          equals(
            json.encode({
              'code': 'USER_ALREADY_EXISTS',
              'message': 'The user already exists',
            }),
          ),
        ),
      );
    });

    test('other than POST responds with empty string', () async {
      final context = _MockRequestContext();
      final request = Request.get(Uri.parse('http://localhost/auth/register'));
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
