import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddNewAction extends StatelessWidget {
  const AddNewAction({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        GoRouter.of(context).push('/todos/new');
      },
      child: Row(
        children: const [
          Icon(
            Icons.add,
          ),
          SizedBox(width: 4),
          Text(
            'Add new',
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
