import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_auth_client/src/auth/auth.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.repository, super.initialState);

  final AuthRepository repository;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      emit(state.copyWith(status: AuthRequest.requestInProgress));

      final response = await repository.login(
        email: email,
        password: password,
      );

      emit(state.copyWith(
        status: AuthRequest.requestSuccess,
        token: response['data'],
      ));
    } catch (_) {
      emit(state.copyWith(status: AuthRequest.requestFailure));
    }
  }

  Future<void> getAuthenticatedUser(String token) async {
    try {
      emit(state.copyWith(userStatus: AuthRequest.requestInProgress));

      final user = await repository.getAuthenticatedUser(token);

      emit(state.copyWith(
        userStatus: AuthRequest.requestSuccess,
        user: AuthUser(
          name: user['name'],
          email: user['email'],
        ),
      ));
    } catch (_) {
      emit(state.copyWith(userStatus: AuthRequest.requestFailure));
    }
  }

  invalidateSession() {
    emit(state.copyWith(
      hasInvalidToken: true,
      token: null,
    ));

    // Refresh auth state
    reset();
  }

  reset() => emit(const AuthState());
}
