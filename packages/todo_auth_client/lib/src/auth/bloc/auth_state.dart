class AuthState {
  AuthState({
    this.status = AuthRequest.unknown,
    this.token,
  });

  final AuthRequest status;
  final String? token;

  AuthState copyWith({AuthRequest? status, String? token}) => AuthState(
        status: status ?? this.status,
        token: token ?? this.token,
      );
}

enum AuthRequest {
  requestFailure,
  requestInProgress,
  requestSuccess,
  unknown,
}
