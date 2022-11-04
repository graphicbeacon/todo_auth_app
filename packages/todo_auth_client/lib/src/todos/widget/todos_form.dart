import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TodosForm extends StatefulWidget {
  const TodosForm({super.key});

  @override
  State<TodosForm> createState() => _TodosFormState();
}

class _TodosFormState extends State<TodosForm> {
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
              labelText: 'Title',
              counterText: '',
            ),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Due date',
              counterText: '',
              hintText: 'DD/MM/YYYY',
              hintStyle: TextStyle(color: Colors.white30),
            ),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Description',
              counterText: '',
            ),
            style: const TextStyle(
              color: Colors.white,
            ),
            maxLines: 4,
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton(
              onPressed: () {
                GoRouter.of(context).pop();
              },
              color: Colors.white,
              child: const Text(
                'Save',
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
