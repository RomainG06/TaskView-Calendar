class Task {
  final String title;
  final String description;
  final DateTime start;
  final DateTime end;
  final DateTime date;
  final bool isNotification;

  Task({
    required this.title,
    required this.description,
    required this.start,
    required this.end,
    required this.date,
    required this.isNotification,
  });
}
