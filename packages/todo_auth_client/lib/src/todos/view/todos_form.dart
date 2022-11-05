import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodosForm extends StatefulWidget {
  const TodosForm({super.key});

  @override
  State<TodosForm> createState() => _TodosFormState();
}

class _TodosFormState extends State<TodosForm> {
  final _formKey = GlobalKey<FormState>();
  final titleCtrl = TextEditingController();
  final dueDateCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();

  DateTime? isValidDate(String date) => DateTime.tryParse(date);

  submitForm() {
    final title = titleCtrl.text;
    final dueDate = dueDateCtrl.text;
    final description = descriptionCtrl.text;

    print(title);
    print(dueDate);
    print(description);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          TextFormField(
            controller: titleCtrl,
            validator: (value) {
              if (value?.isEmpty == true) {
                return 'Please enter the title';
              }

              return null;
            },
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
            controller: dueDateCtrl,
            validator: (value) {
              if (value != null && isValidDate(value) == null) {
                return 'Please enter the due date';
              }

              return null;
            },
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
            controller: descriptionCtrl,
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
              onPressed: submitForm,
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
