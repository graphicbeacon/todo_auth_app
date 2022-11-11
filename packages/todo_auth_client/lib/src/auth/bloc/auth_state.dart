import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthRequest.unknown,
    this.token,
    this.hasInvalidToken,
  });

  final AuthRequest status;
  final String? token;
  final bool? hasInvalidToken;

  AuthState copyWith({
    AuthRequest? status,
    String? token,
    bool? hasInvalidToken,
  }) =>
      AuthState(
        status: status ?? this.status,
        token: token ?? this.token,
        hasInvalidToken: hasInvalidToken ?? this.hasInvalidToken,
      );

  @override
  List<Object?> get props => [status, token, hasInvalidToken];
}

enum AuthRequest {
  requestFailure,
  requestInProgress,
  requestSuccess,
  unknown,
}
