import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  const Todo({
    required this.id,
    required this.title,
    required this.isComplete,
    this.dueDate,
    this.description,
  });

  final String id;
  final String title;
  final bool isComplete;
  final String? dueDate;
  final String? description;

  Todo copyWith({
    String? id,
    String? title,
    bool? isComplete,
    String? dueDate,
    String? description,
  }) =>
      Todo(
        id: id ?? this.id,
        title: title ?? this.title,
        isComplete: isComplete ?? this.isComplete,
        dueDate: dueDate ?? this.dueDate,
        description: description ?? this.description,
      );

  @override
  List<Object?> get props => [id, title, isComplete, dueDate, description];
}
