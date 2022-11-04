import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LogoutAction extends StatelessWidget {
  const LogoutAction({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        GoRouter.of(context).push('/');
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
