import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePickerButton extends StatelessWidget {
  const DatePickerButton({
    required this.onSelectedDate,
    this.isDisabled = false,
    super.key,
  });

  final ValueChanged<DateTime?> onSelectedDate;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CupertinoButton(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 13),
      onPressed: isDisabled
          ? null
          : () async {
              final currDate = DateTime.now();
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: currDate,
                currentDate: currDate,
                firstDate: currDate,
                lastDate: currDate.add(const Duration(days: 365)),
                builder: (context, child) {
                  return Theme(
                      data: theme.copyWith(
                        colorScheme: const ColorScheme.light().copyWith(
                          primary: Colors.deepPurple,
                        ),
                      ),
                      child: child!);
                },
              );

              onSelectedDate(selectedDate);
            },
      child: const Icon(
        Icons.timer,
        color: Colors.deepPurple,
      ),
    );
  }
}
