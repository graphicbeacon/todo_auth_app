import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_auth_client/src/signin/signin.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 60),
              const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
                child: Icon(
                  Icons.app_registration_rounded,
                  color: Colors.deepPurple,
                  size: 40,
                ),
              ),
              const SizedBox(height: 60),
              const SizedBox(
                width: 400,
                child: SigninForm(),
              ),
              const SizedBox(height: 20),
              const Text(
                'or',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 400,
                child: CupertinoButton(
                  onPressed: () {
                    GoRouter.of(context).go('/signup');
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
                      'Sign up',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }
}
