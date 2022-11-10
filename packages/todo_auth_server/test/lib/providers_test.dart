import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:todo_auth_server/todo_auth_server.dart';

import '../../routes/_middleware.dart';

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  // TODO: Fix bad state exception
  // late Store store;

  // setUp(() {
  //   store = Store()
  //     ..memoryDb['users']!.addAll([
  //       {
  //         'id': '645dd7c5-dc1d-4b2d-9729-0174d3d08e91',
  //         'name': 'Johnny',
  //         'email': 'johnny@todo.com',
  //         'password': '0083b3ecada67c5d9608ca9aab4a9'
  //             'cbf19f7ca453fa56e3789320d0013feb7a0',
  //         'salt': 'JISxNzVFqP0ensZHYIVboSZNWt6npZSm5ZqCmc/xiXU=',
  //       },
  //       {
  //         'id': 'b58c03a4-5262-482d-8952-2182a5717875',
  //         'name': 'Charles',
  //         'email': 'charles@todo.com',
  //         'password': '0c3b694765288d7f6a445c6f2daf14'
  //             '58257ddc1de7e572599235ffce43ee4c9a',
  //         'salt': 'RzpV0Nqc9s8HWV8yUtOIkdTz+9PoZEslawCPsqeG7oo=',
  //       },
  //     ])
  //     ..memoryDb['todos']!.addAll([
  //       {
  //         'id': '1',
  //         'userId': '645dd7c5-dc1d-4b2d-9729-0174d3d08e91',
  //         'title': 'My first todo',
  //         'isComplete': false,
  //       },
  //     ]);
  // });

  group('asyncUserProvider()', () {
    test('provides TodoAuthUser.empty()', () async {
      TodoAuthUser? user;
      final handler = middleware((context) async {
        user = await context.read<Future<TodoAuthUser>>();
        return Response(body: '');
      });
      final request = Request.get(Uri.parse('http://localhost/'));
      final context = _MockRequestContext();
      when(() => context.request).thenReturn(request);

      await handler(context);

      expect(user, equals(TodoAuthUser.empty()));
    });

    // TODO: Fix bad state exception
    // test('provides TodoAuthUser', () async {
    //   TodoAuthUser? user;
    //   final handler = middleware((context) async {
    //     user = await context.read<Future<TodoAuthUser>>();
    //     return Response(body: '');
    //   });
    //   final token = generateJwt(
    //     subject: '645dd7c5-dc1d-4b2d-9729-0174d3d08e91',
    //     issuer: TodoAuthServerConstants.jwtIssuer,
    //     secret: TodoAuthServerConstants.jwtSecretKey,
    //   );
    //   final request = Request.post(
    //     Uri.parse('http://localhost/'),
    //     headers: {
    //       'Authorization': 'Bearer $token',
    //     },
    //   );
    //   final context = _MockRequestContext();
    //   when(() => context.request).thenReturn(request);
    //   when(() => context.read<Store>()).thenReturn(store);

    //   await handler(context);

    //   expect(
    //     user,
    //     equals(
    //       const TodoAuthUser(
    //         id: '645dd7c5-dc1d-4b2d-9729-0174d3d08e91',
    //         name: 'Johnny',
    //         email: 'johnny@todo.com',
    //       ),
    //     ),
    //   );
    // });
  });
}
