import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_auth_client/src/services/todo_rest.dart';
import 'package:todo_auth_client/src/register/register.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(
        RegisterRepository(GetIt.I<TodoRestService>()),
      ),
      child: const _RegisterScreenView(
        key: ValueKey('RegisterScreenView'),
      ),
    );
  }
}

class _RegisterScreenView extends StatelessWidget {
  const _RegisterScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: const [
              SizedBox(
                width: 400,
                child: RegisterForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
