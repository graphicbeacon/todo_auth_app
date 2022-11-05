class RegisterState {
  RegisterState({
    this.status = RegisterRequest.unknown,
  });

  final RegisterRequest status;

  RegisterState copyWith({RegisterRequest? status}) => RegisterState(
        status: status ?? this.status,
      );
}

enum RegisterRequest {
  requestFailure,
  requestInProgress,
  requestSuccess,
  unknown,
}
