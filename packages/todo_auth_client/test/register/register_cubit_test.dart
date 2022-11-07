import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_auth_client/src/register/register.dart';

class MockRegisterRepository extends Mock implements RegisterRepository {}

void main() {
  group('RegisterCubit', () {
    late MockRegisterRepository mockApi;
    late RegisterCubit Function([RegisterState]) genRegisterCubit;

    setUp(() {
      mockApi = MockRegisterRepository();
      genRegisterCubit = ([RegisterState? initialState]) => RegisterCubit(
            mockApi,
            // initialState ?? const RegisterState(),
          );
    });

    test('initial state is RegisterState', () {
      expect(genRegisterCubit().state, equals(const RegisterState()));
    });

    group('register()', () {
      blocTest<RegisterCubit, RegisterState>(
        'emits success when invoked',
        build: () => genRegisterCubit(),
        act: (bloc) async {
          when(() => mockApi.createAccount(
                name: 'New user',
                email: 'auth@todo.com',
                password: 'password',
              )).thenAnswer((_) async => {});

          await bloc.registerAccount(
            name: 'New user',
            email: 'auth@todo.com',
            password: 'password',
          );
        },
        expect: () => [
          const RegisterState(status: RegisterRequest.requestInProgress),
          const RegisterState(status: RegisterRequest.requestSuccess),
        ],
      );

      blocTest<RegisterCubit, RegisterState>(
        'emits failure when invoked',
        build: () => genRegisterCubit(),
        act: (bloc) async {
          when(() => mockApi.createAccount(
                name: 'New user',
                email: 'auth@todo.com',
                password: 'password',
              )).thenThrow(Exception('error occured'));

          await bloc.registerAccount(
            name: 'New user',
            email: 'auth@todo.com',
            password: 'password',
          );
        },
        expect: () => [
          const RegisterState(status: RegisterRequest.requestInProgress),
          const RegisterState(status: RegisterRequest.requestFailure),
        ],
      );
    });
  });
}
