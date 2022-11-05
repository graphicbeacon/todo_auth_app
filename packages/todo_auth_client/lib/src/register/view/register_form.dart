import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_auth_client/src/core/core.dart';
import 'package:todo_auth_client/src/register/register.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final repeatPasswordCtrl = TextEditingController();
  AutovalidateMode mode = AutovalidateMode.disabled;

  submitForm() async {
    if (_formKey.currentState?.validate() == true) {
      final name = nameCtrl.text;
      final email = emailCtrl.text;
      final password = passwordCtrl.text;

      await context.read<RegisterCubit>().createAccount(
            name: name,
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
  Widget build(BuildContext context) {
    final isSubmitting = context.select<RegisterCubit, bool>(
      (b) => b.state.status == RegisterRequest.requestInProgress,
    );

    return BlocListener<RegisterCubit, RegisterState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == RegisterRequest.requestSuccess) {
          showAlert(
            context,
            'Successfully created account. You can now sign in.',
            false,
          );

          GoRouter.of(context).go('/');
        }

        if (state.status == RegisterRequest.requestFailure) {
          showAlert(
            context,
            'Problem signing up. Please check and try again',
          );
        }
      },
      child: Form(
        key: _formKey,
        autovalidateMode: mode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            TextFormField(
              readOnly: isSubmitting,
              controller: nameCtrl,
              validator: (value) {
                if (value?.isEmpty == true) {
                  return 'Please enter your name';
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Your name',
                counterText: '',
              ),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              readOnly: isSubmitting,
              controller: emailCtrl,
              validator: (value) {
                if (value?.isEmpty == true) {
                  return 'Please enter your email address';
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
              labelText: 'Password',
              validator: (value) {
                if (value?.isEmpty == true) {
                  return 'Please enter a password';
                }

                if (passwordCtrl.text != repeatPasswordCtrl.text) {
                  return 'Please enter matching passwords';
                }

                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormFieldPassword(
              controller: repeatPasswordCtrl,
              labelText: 'Repeat password',
              validator: (value) {
                if (value?.isEmpty == true) {
                  return 'Please repeat the password';
                }

                if (passwordCtrl.text != repeatPasswordCtrl.text) {
                  return 'Please enter matching passwords';
                }

                return null;
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: CupertinoButton(
                onPressed: isSubmitting ? null : submitForm,
                color: Colors.white,
                child: const Text(
                  'Create',
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
