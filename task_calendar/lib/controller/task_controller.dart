import 'package:task_calendar/model/task.dart';

class TaskController {
  // La liste de tâches utilisé dans l'App
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

  String parseDate(DateTime date) {
    return "";
  }

  void sendTaskToServer() {}
}
