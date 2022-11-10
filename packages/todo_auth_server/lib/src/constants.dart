///
class TodoAuthServerConstants {
  /// In production scenario this will come from an env file
  static const jwtSecretKey = 'todo_auth_app_secret_key';

  ///
  static const jwtIssuer = 'Todo Auth App Server';
}

///
enum TodoAuthResponseErrorCodes {
  ///
  unauthorised('UNAUTHORISED'),

  ///
  invalidPayload('INVALID_PAYLOAD'),

  ///
  invalidCredentials('INVALID_CREDENTIALS'),

  ///
  userAlreadyExists('USER_ALREADY_EXISTS');

  ///
  const TodoAuthResponseErrorCodes(this.value);

  ///
  final String value;
}
