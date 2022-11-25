import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthRequest.unknown,
    this.token,
    this.userStatus = AuthRequest.unknown,
    this.user,
    this.hasInvalidToken,
  });

  final AuthRequest status;
  final String? token;
  final AuthRequest userStatus;
  final AuthUser? user;
  final bool? hasInvalidToken;

  AuthState copyWith({
    AuthRequest? status,
    String? token,
    AuthRequest? userStatus,
    AuthUser? user,
    bool? hasInvalidToken,
  }) =>
      AuthState(
        status: status ?? this.status,
        token: token ?? this.token,
        userStatus: userStatus ?? this.userStatus,
        user: user ?? this.user,
        hasInvalidToken: hasInvalidToken ?? this.hasInvalidToken,
      );

  @override
  List<Object?> get props => [status, token, userStatus, user, hasInvalidToken];
}

class AuthUser extends Equatable {
  const AuthUser({
    required this.name,
    required this.email,
  });

  final String name;
  final String email;

  @override
  List<String> get props => [name, email];
}

enum AuthRequest {
  requestFailure,
  requestInProgress,
  requestSuccess,
  unknown,
}
