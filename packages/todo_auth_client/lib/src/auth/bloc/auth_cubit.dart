import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_auth_client/src/auth/auth.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.repository) : super(AuthState());

  final AuthRepository repository;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      emit(state.copyWith(status: AuthRequest.requestInProgress));

      final token = await repository.login(
        email: email,
        password: password,
      );

      emit(state.copyWith(
        status: AuthRequest.requestSuccess,
        token: token,
      ));
    } catch (_) {
      emit(state.copyWith(status: AuthRequest.requestFailure));
    }
  }

  reset() => emit(AuthState());
}
