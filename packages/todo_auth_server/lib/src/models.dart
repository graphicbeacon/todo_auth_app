/// Represents a logged in user
class TodoAuthUser {
  ///
  const TodoAuthUser({
    required this.id,
    required this.name,
    required this.email,
  });

  ///
  final String id;

  ///
  final String name;

  ///
  final String email;
}
