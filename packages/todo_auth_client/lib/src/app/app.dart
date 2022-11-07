import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_auth_client/src/auth/auth.dart';
import 'package:todo_auth_client/src/core/core.dart';
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
        const AuthState(),
      ),
      child: const _AppView(key: ValueKey('AppView')),
    );
  }
}

class _AppView extends StatefulWidget {
  const _AppView({super.key});

  @override
  AppViewState createState() => AppViewState();
}

class AppViewState extends State<_AppView> {
  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => AuthScreen(),
        routes: [
          GoRoute(
            path: 'register',
            builder: (context, state) => const RegisterScreen(),
          ),
        ],
        redirect: (context, state) {
          final authState = context.read<AuthCubit>().state;
          if (authState.token != null) {
            return '/todos';
          }

          return null;
        },
      ),
      ShellRoute(
        builder: (context, state, child) {
          return BlocProvider(
            create: (context) => TodosCubit(
              TodosRepository(
                GetIt.I<TodoRestService>(),
              ),
              const TodosState(),
            ),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/todos',
            builder: (context, state) => const TodosScreen(),
            routes: [
              GoRoute(
                path: 'new',
                builder: (context, state) =>
                    const TodosFormScreen(title: 'New Todo'),
              ),
              GoRoute(
                path: 'edit',
                builder: (context, state) {
                  if (state.extra is! Map<String, dynamic>) {
                    throw Exception('Missing required "id" parameter');
                  }

                  return TodosFormScreen(
                    title: 'Edit Todo',
                    editId: (state.extra as Map)['id'],
                  );
                },
              ),
            ],
            redirect: (context, state) {
              final authState = context.read<AuthCubit>().state;
              if (authState.token == null) {
                return '/';
              }

              return null;
            },
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
      theme: theme,
      title: 'Todo Auth App',
    );
  }
}
