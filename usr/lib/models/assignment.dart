class Assignment {
  final String id;
  final String title;
  final String subject;
  final DateTime dueDate;
  bool isCompleted;

  Assignment({
    required this.id,
    required this.title,
    required this.subject,
    required this.dueDate,
    this.isCompleted = false,
  });
}
