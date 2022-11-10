import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:todo_auth_server/todo_auth_server.dart';

import '../../../routes/todos/list.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  late Store store;

  setUp(() {
    store = store = Store()
      ..memoryDb['users']!.addAll([
        {
          'id': '645dd7c5-dc1d-4b2d-9729-0174d3d08e91',
          'name': 'Johnny',
          'email': 'johnny@todo.com',
          'password': '0083b3ecada67c5d9608ca9aab4a9cb'
              'f19f7ca453fa56e3789320d0013feb7a0',
          'salt': 'JISxNzVFqP0ensZHYIVboSZNWt6npZSm5ZqCmc/xiXU=',
        },
        {
          'id': 'b58c03a4-5262-482d-8952-2182a5717875',
          'name': 'Charles',
          'email': 'charles@todo.com',
          'password': '0c3b694765288d7f6a445c6f2daf1458'
              '257ddc1de7e572599235ffce43ee4c9a',
          'salt': 'RzpV0Nqc9s8HWV8yUtOIkdTz+9PoZEslawCPsqeG7oo=',
        },
      ])
      ..memoryDb['todos']!.addAll([
        {
          'id': '1',
          'userId': '645dd7c5-dc1d-4b2d-9729-0174d3d08e91',
          'title': 'My first todo',
          'isComplete': false,
        },
        {
          'id': '2',
          'userId': '645dd7c5-dc1d-4b2d-9729-0174d3d08e91',
          'title': 'My second todo',
          'dueDate': '2022-12-12',
          'description': 'lorem ipsum dolor sit amet',
          'isComplete': false,
        },
        {
          'id': '3',
          'userId': 'b58c03a4-5262-482d-8952-2182a5717875',
          'title': 'My third todo',
          'description': 'lorem ipsum dolor sit amet',
          'isComplete': false,
        },
      ]);
  });

  tearDown(() {
    store
      ..memoryDb['users']!.clear()
      ..memoryDb['todos']!.clear();
  });

  group('/todos/list', () {
    test('POST responds with a 200 and todos', () async {
      final context = _MockRequestContext();
      const user = TodoAuthUser(
        id: '645dd7c5-dc1d-4b2d-9729-0174d3d08e91',
        name: 'Johnny',
        email: 'johnny@todo.com',
      );
      final request = Request.post(Uri.parse('http://localhost/todos/list'));

      when(() => context.request).thenReturn(request);
      when(() => context.read<Store>()).thenReturn(store);
      when(() => context.read<Future<TodoAuthUser>>())
          .thenAnswer((_) async => user);

      final response = await route.onRequest(context);
      final body = await response.body();
      final decodedBody = json.decode(body) as Map<String, dynamic>;

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(
        decodedBody['message'],
        equals(
          [
            {
              'id': '1',
              'userId': '645dd7c5-dc1d-4b2d-9729-0174d3d08e91',
              'title': 'My first todo',
              'isComplete': false,
            },
            {
              'id': '2',
              'userId': '645dd7c5-dc1d-4b2d-9729-0174d3d08e91',
              'title': 'My second todo',
              'dueDate': '2022-12-12',
              'description': 'lorem ipsum dolor sit amet',
              'isComplete': false,
            },
          ],
        ),
      );
    });

    test('POST responds with a 200 and other todos', () async {
      final context = _MockRequestContext();
      const user = TodoAuthUser(
        id: 'b58c03a4-5262-482d-8952-2182a5717875',
        name: 'Johnny',
        email: 'johnny@todo.com',
      );
      final request = Request.post(Uri.parse('http://localhost/todos/list'));
      when(() => context.request).thenReturn(request);
      when(() => context.read<Store>()).thenReturn(store);
      when(() => context.read<Future<TodoAuthUser>>())
          .thenAnswer((_) async => user);

      final response = await route.onRequest(context);
      final body = await response.body();
      final decodedBody = json.decode(body) as Map<String, dynamic>;

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(
        decodedBody['message'],
        equals(
          [
            {
              'id': '3',
              'userId': 'b58c03a4-5262-482d-8952-2182a5717875',
              'title': 'My third todo',
              'description': 'lorem ipsum dolor sit amet',
              'isComplete': false,
            },
          ],
        ),
      );
    });

    test('POST responds with a 401 if empty user', () async {
      final context = _MockRequestContext();
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
      final request = Request.get(Uri.parse('http://localhost/todos/list'));

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
