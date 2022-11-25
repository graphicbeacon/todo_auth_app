import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_auth_client/src/auth/auth.dart';
import 'package:todo_auth_client/src/core/core.dart';
import 'package:todo_auth_client/src/dashboard/dashboard.dart';
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
  @override
  void initState() {
    super.initState();

    // Add interceptor for token expiry
    GetIt.I<TodoRestService>().client.interceptors.add(InvalidTokenInterceptor(
      onInvalidToken: () {
        context.read<AuthCubit>().invalidateSession();
      },
    ));
  }

  final _router = GoRouter(
    routes: [
      GoRoute(
        path: TodoAuthAppPaths.root,
        builder: (context, state) => AuthScreen(),
        routes: [
          GoRoute(
            path: TodoAuthAppPaths.register,
            builder: (context, state) => const RegisterScreen(),
          ),
        ],
        redirect: (context, state) {
          final authState = context.read<AuthCubit>().state;
          if (authState.token != null) {
            return TodoAuthAppPaths.dashboard;
          }

          return null;
        },
      ),
      ShellRoute(
        builder: (context, state, child) {
          return BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              // Redirect to login if session token invalidates or expires
              if (state.hasInvalidToken == true) {
                showAlert(context, 'Token expired. Please log in again.');
                context.go(TodoAuthAppPaths.root);
              }
            },
            child: BlocProvider(
              create: (context) => TodosCubit(
                TodosRepository(
                  GetIt.I<TodoRestService>(),
                ),
                const TodosState(),
              ),
              child: child,
            ),
          );
        },
        routes: [
          GoRoute(
            path: TodoAuthAppPaths.dashboard,
            builder: (context, state) => const DashboardScreen(),
            routes: [
              GoRoute(
                path: 'newTodo',
                builder: (context, state) =>
                    const TodosFormScreen(title: 'New Todo'),
              ),
              GoRoute(
                path: 'editTodo',
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
                return TodoAuthAppPaths.root;
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
