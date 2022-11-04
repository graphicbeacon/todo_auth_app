class Todo {
  Todo({
    required this.id,
    required this.title,
    this.isComplete = false,
    this.dueDate,
    this.description,
  });

  final String id;
  final String title;
  final bool isComplete;
  final DateTime? dueDate;
  final String? description;
}
