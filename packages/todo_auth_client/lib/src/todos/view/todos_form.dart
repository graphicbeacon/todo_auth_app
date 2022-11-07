import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_auth_client/src/auth/bloc/auth_cubit.dart';
import 'package:todo_auth_client/src/core/core.dart';
import 'package:todo_auth_client/src/todos/todos.dart';

class TodosForm extends StatefulWidget {
  const TodosForm({this.data, super.key});

  final Todo? data;

  @override
  State<TodosForm> createState() => _TodosFormState();
}

class _TodosFormState extends State<TodosForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleCtrl;
  late TextEditingController dueDateCtrl;
  late TextEditingController descriptionCtrl;
  AutovalidateMode mode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();

    titleCtrl = TextEditingController(text: widget.data?.title);
    dueDateCtrl = TextEditingController(text: widget.data?.dueDate);
    descriptionCtrl = TextEditingController(text: widget.data?.description);
  }

  DateTime? isValidDate(String date) {
    final dateParts = date.trim().split('/').reversed;
    return DateTime.tryParse(dateParts.join('-'));
  }

  submitForm() async {
    if (_formKey.currentState?.validate() == true) {
      final title = titleCtrl.text;
      final dueDate = dueDateCtrl.text;
      final description = descriptionCtrl.text;

      final authState = context.read<AuthCubit>().state;

      if (authState.token == null) return;

      if (widget.data?.id == null) {
        // Creating new todo
        await context.read<TodosCubit>().createTodo(
              title: title,
              dueDate: dueDate,
              description: description,
              token: authState.token!,
            );

        // end execution here
        return;
      }

      // Editing a todo
      final prevTodo = context
          .read<TodosCubit>()
          .state
          .todos
          .singleWhere((todo) => todo.id == widget.data?.id);

      await context.read<TodosCubit>().updateTodo(
            token: authState.token!,
            todo: prevTodo.copyWith(
              title: title,
              dueDate: dueDate,
              description: description,
            ),
          );
    } else {
      setState(() {
        mode = AutovalidateMode.always;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = context.select<TodosCubit, bool>(
      (b) => b.state.formStatus == TodosRequest.requestInProgress,
    );

    return BlocListener<TodosCubit, TodosState>(
      listenWhen: (prev, curr) => prev.formStatus != curr.formStatus,
      listener: (context, state) {
        if (state.formStatus == TodosRequest.requestSuccess) {
          showAlert(
            context,
            'Successfully updated todo',
            false,
          );

          context.go('/todos');
        }

        if (state.formStatus == TodosRequest.requestFailure) {
          showAlert(
            context,
            'Problem saving changes. Please check and try again',
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
            Row(
              children: [
                DatePickerButton(
                  isDisabled: isSubmitting,
                  onSelectedDate: (date) {
                    if (date != null) {
                      dueDateCtrl.text = date.toIso8601String();
                    }
                  },
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: dueDateCtrl,
                    readOnly: true,
                    validator: (value) {
                      if (value != null &&
                          value.isNotEmpty == true &&
                          isValidDate(value) == null) {
                        return 'Please enter the due date';
                      }

                      return null;
                    },
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
              ],
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
      ),
    );
  }
}
