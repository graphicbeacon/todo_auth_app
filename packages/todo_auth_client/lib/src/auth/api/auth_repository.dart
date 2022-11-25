import 'package:todo_auth_client/src/services/todo_rest.dart';

class AuthRepository {
  const AuthRepository(this.service);

  final TodoRestService service;

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) {
    return service.login(
      email: email,
      password: password,
    );
  }

  Future<Map<String, dynamic>> getAuthenticatedUser(String token) {
    return service.getAuthenticatedUser(token);
  }
}
