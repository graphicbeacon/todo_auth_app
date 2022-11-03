import 'package:flutter/material.dart';
import 'package:todo_auth_client/src/signup/signup.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

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
                child: SignupForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
