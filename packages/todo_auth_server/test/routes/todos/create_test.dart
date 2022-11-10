import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:todo_auth_server/todo_auth_server.dart';

import '../../../routes/todos/create.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  late Store store;

  setUp(() {
    store = Store()
      ..memoryDb['users']!.addAll([
        {
          'id': '645dd7c5-dc1d-4b2d-9729-0174d3d08e91',
          'name': 'Johnny',
          'email': 'johnny@todo.com',
          'password': '0083b3ecada67c5d9608ca9aab4a9'
              'cbf19f7ca453fa56e3789320d0013feb7a0',
          'salt': 'JISxNzVFqP0ensZHYIVboSZNWt6npZSm5ZqCmc/xiXU=',
        },
        {
          'id': 'b58c03a4-5262-482d-8952-2182a5717875',
          'name': 'Charles',
          'email': 'charles@todo.com',
          'password': '0c3b694765288d7f6a445c6f2daf14'
              '58257ddc1de7e572599235ffce43ee4c9a',
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
      ]);
  });

  tearDown(() {
    store
      ..memoryDb['users']!.clear()
      ..memoryDb['todos']!.clear();
  });

  group('/todos/create', () {
    test('POST responds with 200', () async {
      final context = _MockRequestContext();
      const user = TodoAuthUser(
        id: 'b58c03a4-5262-482d-8952-2182a5717875',
        name: 'Johnny',
        email: 'johnny@todo.com',
      );
      final request = Request.post(
        Uri.parse('http://localhost/todos/create'),
        body: json.encode({
          'title': 'My other todo',
          'dueDate': '2022-11-11',
          'description': 'Lorem ipsum dolor',
        }),
      );

      when(() => context.request).thenReturn(request);
      when(() => context.read<Store>()).thenReturn(store);
      when(() => context.read<Future<TodoAuthUser>>())
          .thenAnswer((_) async => user);

      final response = await route.onRequest(context);
      final body = await response.body();
      final decodedBody = json.decode(body) as Map<String, dynamic>;

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(decodedBody['id'], matches('.+'));
      expect(
        decodedBody['userId'],
        equals('b58c03a4-5262-482d-8952-2182a5717875'),
      );
      expect(decodedBody['title'], equals('My other todo'));
      expect(decodedBody['dueDate'], equals('2022-11-11'));
      expect(decodedBody['description'], equals('Lorem ipsum dolor'));
      expect(decodedBody['isComplete'], isFalse);
      expect(store.memoryDb['todos']!.last['id'], matches('.+'));
      expect(
        store.memoryDb['todos']!.last['userId'],
        equals('b58c03a4-5262-482d-8952-2182a5717875'),
      );
      expect(
        store.memoryDb['todos']!.last['title'],
        equals('My other todo'),
      );
      expect(
        store.memoryDb['todos']!.last['dueDate'],
        equals('2022-11-11'),
      );
      expect(
        store.memoryDb['todos']!.last['description'],
        equals('Lorem ipsum dolor'),
      );
      expect(
        store.memoryDb['todos']!.last['isComplete'],
        isFalse,
      );
    });

    test('POST responds with a 401 if invalid payload', () async {
      final context = _MockRequestContext();
      final request = Request.post(
        Uri.parse('http://localhost/todos/create'),
        body: json.encode({'title': null}),
      );

      when(() => context.request).thenReturn(request);

      final response = await route.onRequest(context);
      final body = await response.body();
      final decodedBody = json.decode(body) as Map<String, dynamic>;

      expect(response.statusCode, equals(HttpStatus.badRequest));
      expect(decodedBody['code'], equals('INVALID_PAYLOAD'));
      expect(decodedBody['message'], equals('Please provide required data'));
    });

    test('POST responds with 401 if invalid user', () async {
      final context = _MockRequestContext();
      final request = Request.post(
        Uri.parse('http://localhost/todos/create'),
        body: json.encode({'title': 'my todo'}),
      );

      when(() => context.request).thenReturn(request);
      when(() => context.read<Future<TodoAuthUser>>())
          .thenAnswer((_) async => TodoAuthUser.empty());

      final response = await route.onRequest(context);
      final body = await response.body();
      final decodedBody = json.decode(body) as Map<String, dynamic>;

      expect(response.statusCode, equals(HttpStatus.unauthorized));
      expect(decodedBody['code'], equals('UNAUTHORISED'));
      expect(decodedBody['message'], equals('Unauthorised'));
    });
  });
}
