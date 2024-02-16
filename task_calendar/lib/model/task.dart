class Task {
  final String title;
  final String description;
  final String start;
  final String end;
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
      'start': start,
      'end': end,
      'date': date.toIso8601String(),
      'isNotification': isNotification,
    };
  }

  // Retourne une tache à partir d'un JSON utilisé pour le format en SharedPreference
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      description: json['description'],
      start: json['start'],
      end: json['end'],
      date: DateTime.parse(json['date']),
      isNotification: json['isNotification'],
    );
  }
}
