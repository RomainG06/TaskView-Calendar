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

// Convertit une tache en json permettant de l'envoyer au bon format aus erveur
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
      'date': date.toIso8601String(),
      'isNotification': isNotification,
    };
  }
}
