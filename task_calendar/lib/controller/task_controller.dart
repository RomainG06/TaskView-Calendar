import 'package:intl/intl.dart';
import 'package:task_calendar/model/task.dart';

class TaskController {
  // La liste des tâches complete utilisé dans l'App
  List<Task> tasks = [];

  // Chargement local de tâche
  void loadTasks() {
    tasks = [
      Task(
          title: "Task1",
          description: "Description1",
          start: DateTime.now(),
          end: DateTime.now(),
          date: DateTime.now(),
          isNotification: false),
      Task(
          title: "Task2",
          description: "Description2",
          start: DateTime.now(),
          end: DateTime.now(),
          date: DateTime.now(),
          isNotification: false),
      Task(
          title: "Task3",
          description: "Description3",
          start: DateTime.now(),
          end: DateTime.now(),
          date: DateTime.now(),
          isNotification: false),
    ];
  }

// Permet de retourner les heures et les minutes à partir d'une date
  String parseDateHour(DateTime date) {
    String hour = date.hour.toString();
    String minutes = date.minute.toString();
    return "$hour: $minutes";
  }

// Permet de retourner le jour/mois/année d'une date en francais
  String parseDateDay(DateTime date) {
    String locale = "fr_FR";
    String day = DateFormat.EEEE(locale).format(date);
    String dayMonth = DateFormat.MMMMd(locale).format(date);
    String year = DateFormat.y(locale).format(date);
    return "${day.toUpperCase()} ${dayMonth.toUpperCase()} $year";
  }

  void sendTaskToServer() {}
}
