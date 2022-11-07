import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_auth_client/src/register/register.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this.repository) : super(const RegisterState());

  final RegisterRepository repository;

  Future<void> registerAccount({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      emit(state.copyWith(status: RegisterRequest.requestInProgress));

      await repository.createAccount(
        name: name,
        email: email,
        password: password,
      );

      emit(state.copyWith(status: RegisterRequest.requestSuccess));
    } catch (_) {
      emit(state.copyWith(status: RegisterRequest.requestFailure));
    }
  }
}
