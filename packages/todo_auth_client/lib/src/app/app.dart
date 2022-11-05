import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_auth_client/src/auth/auth.dart';
import 'package:todo_auth_client/src/services/services.dart';
import 'package:todo_auth_client/src/register/register.dart';
import 'package:todo_auth_client/src/todos/todos.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(
        AuthRepository(GetIt.I<TodoRestService>()),
      ),
      child: _AppView(key: const ValueKey('AppView')),
    );
  }
}

class _AppView extends StatelessWidget {
  _AppView({super.key});

  final _router = GoRouter(
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) => const AuthScreen(),
        routes: [
          GoRoute(
            path: "register",
            builder: (context, state) => const RegisterScreen(),
          ),
        ],
      ),
      GoRoute(
        path: "/todos",
        builder: (context, state) => const TodosScreen(),
        routes: [
          GoRoute(
            path: "new",
            builder: (context, state) =>
                const TodosFormScreen(title: 'New Todo'),
          ),
          GoRoute(
            path: "edit",
            builder: (context, state) =>
                const TodosFormScreen(title: 'Edit Todo'),
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(
            color: Colors.white,
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.white,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.white,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.purpleAccent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorStyle: const TextStyle(
            color: Colors.orangeAccent,
          ),
        ),
      ),
      title: 'Todo Auth App',
    );
  }
}
