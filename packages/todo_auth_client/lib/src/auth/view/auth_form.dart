import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_auth_client/src/auth/auth.dart';
import 'package:todo_auth_client/src/core/core.dart';

class SigninForm extends StatefulWidget {
  const SigninForm({required this.formKey, super.key});

  final GlobalKey<FormState> formKey;

  @override
  State<SigninForm> createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  AutovalidateMode mode = AutovalidateMode.disabled;

  submitForm() async {
    if (widget.formKey.currentState?.validate() == true) {
      final email = emailCtrl.text;
      final password = passwordCtrl.text;

      await context.read<AuthCubit>().login(
            email: email,
            password: password,
          );
    } else {
      setState(() {
        mode = AutovalidateMode.always;
      });
    }
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = context.select<AuthCubit, bool>(
      (b) => b.state.status == AuthRequest.requestInProgress,
    );

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthRequest.requestSuccess && state.token != null) {
          context.go('/todos');

          showAlert(
            context,
            'Welcome!',
            false,
          );
        }

        if (state.status == AuthRequest.requestFailure) {
          showAlert(
            context,
            'Problem logging in. Please check your details and try again',
          );
        }
      },
      child: Form(
        key: widget.formKey,
        autovalidateMode: mode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            TextFormField(
              controller: emailCtrl,
              validator: (value) {
                if (value?.isEmpty == true || value?.contains('@') == false) {
                  return 'Please enter a valid email address';
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Email address',
                counterText: '',
              ),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            TextFormFieldPassword(
              controller: passwordCtrl,
              validator: (value) {
                if (value?.isEmpty == true) {
                  return 'Please enter a valid password';
                }

                return null;
              },
              labelText: 'Password',
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: CupertinoButton(
                onPressed: isSubmitting ? null : submitForm,
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
      ),
    );
  }
}
