import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.status = RegisterRequest.unknown,
  });

  final RegisterRequest status;

  RegisterState copyWith({RegisterRequest? status}) => RegisterState(
        status: status ?? this.status,
      );

  @override
  List<RegisterRequest> get props => [status];
}

enum RegisterRequest {
  requestFailure,
  requestInProgress,
  requestSuccess,
  unknown,
}
