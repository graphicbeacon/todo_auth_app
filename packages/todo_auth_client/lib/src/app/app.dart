import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_auth_client/src/signin/signin.dart';
import 'package:todo_auth_client/src/signup/signup.dart';
import 'package:todo_auth_client/src/todos/todos.dart';

class App extends StatelessWidget {
  App({super.key});

  final _router = GoRouter(
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) => const SigninScreen(),
        routes: [
          GoRoute(
            path: "signup",
            builder: (context, state) => const SignupScreen(),
          ),
        ],
      ),
      GoRoute(
        path: "/todos",
        builder: (context, state) => const TodosScreen(),
        routes: [
          GoRoute(
            path: "edit",
            builder: (context, state) => const TodosEditScreen(),
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
        ),
      ),
      title: 'Todo Auth App',
    );
  }
}
