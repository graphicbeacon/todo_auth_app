import 'package:flutter/material.dart';

class TodoListCheckbox extends StatefulWidget {
  const TodoListCheckbox({
    required this.isChecked,
    required this.onChanged,
    super.key,
  });

  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  @override
  State<TodoListCheckbox> createState() => _TodoListCheckboxState();
}

class _TodoListCheckboxState extends State<TodoListCheckbox> {
  bool? _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Checkbox(
      value: _isChecked,
      fillColor: MaterialStateProperty.all(theme.primaryColor),
      onChanged: (value) {
        setState(() {
          _isChecked = value;
          widget.onChanged(value);
        });
      },
    );
  }
}
