/// Represents a logged in user
class TodoAuthUser {
  ///
  const TodoAuthUser({
    required this.id,
    required this.name,
    required this.email,
  });

  ///
  factory TodoAuthUser.empty() => const TodoAuthUser(
        id: '',
        name: '',
        email: '',
      );

  ///
  final String id;

  ///
  final String name;

  ///
  final String email;

  ///
  bool get isEmpty => [id, name, email].every((field) => field.isEmpty);
}
