import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthRequest.unknown,
    this.token,
  });

  final AuthRequest status;
  final String? token;

  AuthState copyWith({AuthRequest? status, String? token}) => AuthState(
        status: status ?? this.status,
        token: token ?? this.token,
      );

  @override
  List<Object?> get props => [status, token];
}

enum AuthRequest {
  requestFailure,
  requestInProgress,
  requestSuccess,
  unknown,
}
