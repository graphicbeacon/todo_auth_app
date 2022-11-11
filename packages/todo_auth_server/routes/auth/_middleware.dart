import 'package:dart_frog/dart_frog.dart';
import 'package:todo_auth_server/todo_auth_server.dart';

Handler middleware(Handler handler) {
  return handler.use(verifyJwtToken()).use(asyncUserProvider());
}
