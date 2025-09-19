class Task {
  final String id;
  final String title;
  final String subtitle;
  bool completed;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.subtitle = '',
    this.completed = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
