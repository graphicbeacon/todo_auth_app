import 'package:todo_auth_client/src/services/services.dart';

class RegisterRepository {
  const RegisterRepository(this.service);

  final TodoRestService service;

  Future createAccount({
    required String name,
    required String email,
    required String password,
  }) {
    return Future.value({});
  }
}
