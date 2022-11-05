import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_auth_client/src/auth/auth.dart';

class LogoutAction extends StatelessWidget {
  const LogoutAction({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<AuthCubit>().reset();
        context.go('/');
      },
      child: Row(
        children: const [
          Icon(
            Icons.logout_outlined,
          ),
          SizedBox(width: 4),
          Text(
            'Log out',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 4),
        ],
      ),
    );
  }
}
