import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_auth_client/src/auth/auth.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SizedBox(
            width: 400,
            child: Column(
              children: [
                const SizedBox(height: 60),
                const TodoAppLogo(),
                const SizedBox(height: 40),
                SigninForm(formKey: formKey),
                const SizedBox(height: 20),
                CupertinoButton(
                  onPressed: () {
                    formKey.currentState?.reset();
                    context.go('/register');
                  },
                  color: Colors.transparent,
                  padding: EdgeInsets.zero,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Register',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
