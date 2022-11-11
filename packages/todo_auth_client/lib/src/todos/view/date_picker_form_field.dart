import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_auth_client/src/todos/todos.dart';

class DatePickerFormField extends StatelessWidget {
  const DatePickerFormField({
    required this.onSelectedDate,
    required this.controller,
    required this.validator,
    this.isDisabled = false,
    super.key,
  });

  final ValueChanged<DateTime?> onSelectedDate;
  final String? Function(String?) validator;
  final TextEditingController controller;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DatePickerButton(
          isDisabled: isDisabled,
          onSelectedDate: onSelectedDate,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: controller,
            readOnly: true,
            validator: validator,
            decoration: const InputDecoration(
              labelText: 'Due date',
              counterText: '',
              hintText: '<== Select due date',
              hintStyle: TextStyle(color: Colors.white30),
            ),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 5),
        CupertinoButton(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 13),
          onPressed: isDisabled
              ? null
              : () async {
                  controller.clear();
                },
          child: const Icon(
            Icons.clear,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
