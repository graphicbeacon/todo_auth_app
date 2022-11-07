import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  Todo({
    required this.id,
    required this.title,
    required this.isComplete,
    this.dueDate,
    this.description,
    this.isUpdating,
  });

  final String id;
  final String title;
  final bool isComplete;
  final String? dueDate;
  final String? description;
  final bool? isUpdating;

  Todo copyWith({
    String? id,
    String? title,
    bool? isComplete,
    String? dueDate,
    String? description,
    bool? isUpdating,
  }) =>
      Todo(
        id: id ?? this.id,
        title: title ?? this.title,
        isComplete: isComplete ?? this.isComplete,
        dueDate: dueDate ?? this.dueDate,
        description: description ?? this.description,
        isUpdating: isUpdating ?? this.isUpdating,
      );

  @override
  List<Object?> get props =>
      [id, title, isComplete, dueDate, description, isUpdating];
}
