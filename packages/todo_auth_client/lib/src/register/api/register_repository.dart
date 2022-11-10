import 'package:todo_auth_client/src/services/services.dart';

class RegisterRepository {
  const RegisterRepository(this.service);

  final TodoRestService service;

  Future<String> registerAccount({
    required String name,
    required String email,
    required String password,
  }) async {
    return service.registerAccount(
      name: name,
      email: email,
      password: password,
    );
  }
}
