import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_auth_client/src/auth/auth.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('AuthCubit', () {
    late MockAuthRepository mockApi;
    late AuthCubit Function([AuthState]) genAuthCubit;

    setUp(() {
      mockApi = MockAuthRepository();
      genAuthCubit = ([AuthState? initialState]) => AuthCubit(
            mockApi,
            initialState ?? const AuthState(),
          );
    });

    test('initial state is AuthState', () {
      expect(genAuthCubit().state, equals(const AuthState()));
    });

    group('login()', () {
      blocTest<AuthCubit, AuthState>(
        'emits success when invoked',
        build: () => genAuthCubit(),
        act: (bloc) async {
          when(() => mockApi.login(
                email: 'auth@todo.com',
                password: 'password',
              )).thenAnswer((_) async => 'my token');

          await bloc.login(
            email: 'auth@todo.com',
            password: 'password',
          );
        },
        expect: () => [
          const AuthState(status: AuthRequest.requestInProgress),
          const AuthState(
            status: AuthRequest.requestSuccess,
            token: 'my token',
          ),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'emits failure when invoked',
        build: () => genAuthCubit(),
        act: (bloc) async {
          when(() => mockApi.login(
                email: 'auth@todo.com',
                password: 'password',
              )).thenThrow(Exception('error'));

          await bloc.login(
            email: 'auth@todo.com',
            password: 'password',
          );
        },
        expect: () => [
          const AuthState(status: AuthRequest.requestInProgress),
          const AuthState(status: AuthRequest.requestFailure),
        ],
      );
    });

    group('reset()', () {
      blocTest<AuthCubit, AuthState>(
        'resets state when invoked',
        build: () => genAuthCubit(const AuthState(
          status: AuthRequest.requestSuccess,
          token: 'my token',
        )),
        act: (bloc) => bloc.reset(),
        expect: () => const [AuthState()],
      );
    });
  });
}
