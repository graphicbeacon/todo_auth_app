import 'package:flutter/material.dart';
import 'package:todo_auth_client/src/app/app.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_auth_client/src/services/todo_rest.dart';

void main() {
  GetIt.I.registerSingleton<TodoRestService>(TodoRestService());

  runApp(App());
}
