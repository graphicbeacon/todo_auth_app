import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_auth_client/src/core/core.dart';

class SigninForm extends StatefulWidget {
  const SigninForm({super.key});

  @override
  State<SigninForm> createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Email address',
              counterText: '',
            ),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          const TextFormFieldPassword(
            labelText: 'Password',
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton(
              onPressed: () {
                GoRouter.of(context).go('/todos');
              },
              color: Colors.white,
              child: const Text(
                'Sign in',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
