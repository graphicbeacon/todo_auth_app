import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_auth_client/src/auth/auth.dart';

class HelloUser extends StatelessWidget {
  const HelloUser({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state.userStatus == AuthRequest.unknown && state.token != null) {
          context.read<AuthCubit>().getAuthenticatedUser(state.token!);
          return Container();
        }

        if ([AuthRequest.requestInProgress, AuthRequest.requestFailure]
            .contains(state.userStatus)) {
          return Container();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome ${state.user?.name}!',
              style: const TextStyle(
                color: Colors.blueGrey,
                fontSize: 22,
                // fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
          ],
        );
      },
    );
  }
}
