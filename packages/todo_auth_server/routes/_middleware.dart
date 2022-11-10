import 'package:dart_frog/dart_frog.dart';
import 'package:todo_auth_server/todo_auth_server.dart';

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<Store>((_) => Store()))
      .use(asyncUserProvider());
}
