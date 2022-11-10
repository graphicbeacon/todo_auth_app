import 'package:todo_auth_client/src/services/todo_rest.dart';

class AuthRepository {
  const AuthRepository(this.service);

  final TodoRestService service;

  Future<String> login({
    required String email,
    required String password,
  }) {
    return service.login(
      email: email,
      password: password,
    );
  }
}
