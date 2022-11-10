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
      const user = TodoAuthUser(
        id: '645dd7c5-dc1d-4b2d-9729-0174d3d08e91',
        name: 'Johnny',
        email: 'johnny@todo.com',
      );
      final request = Request.post(Uri.parse('http://localhost/auth/user'));

      when(() => context.request).thenReturn(request);
      when(() => context.read<Future<TodoAuthUser>>())
          .thenAnswer((_) async => user);

      final response = await route.onRequest(context);
      final body = await response.body();
      final decodedBody = json.decode(body) as Map<String, dynamic>;

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(decodedBody['data'], equals('Johnny'));
    });

    test('POST responds with a 401 if user does not exist', () async {
      final context = _MockRequestContext();
      final store = Store();
      final request = Request.post(Uri.parse('http://localhost/auth/user'));

      when(() => context.request).thenReturn(request);
      when(() => context.read<Store>()).thenReturn(store);
      when(() => context.read<Future<TodoAuthUser>>())
          .thenAnswer((_) async => TodoAuthUser.empty());

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
