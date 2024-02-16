import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_calendar/controller/services/api.dart';
import 'package:task_calendar/model/task.dart';

class TaskController {
  // Structure de donnée Map Date - ListTaches
  Map<DateTime, List<Task>> tasks = {};
  List<Task> allTasks = [];

// Récupère toutes les tâches tout jours confondus
  List<Task> getAllTask() {
    tasks.values.forEach((taskList) {
      allTasks.addAll(taskList);
    });
    return allTasks;
  }

// convertir la liste de tache en Map et la récupère des SharedPreferences
  loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedTasks = prefs.getString('tasks');
    if (storedTasks != null) {
      tasks = convertTasksMap(storedTasks);
    } else {
      tasks = {};
    }
  }

// convertir la liste de tache en JSON et la stocke dans les SharedPreferences
  storeTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tasksJson = convertTasksJson(tasks);
    prefs.setString('tasks', tasksJson);
  }

  // Supprimer la tache lié au jour
  void deleteTask(DateTime date, Task task) {
    if (tasks.containsKey(date)) {
      tasks[date]?.remove(task);
      storeTasks();
    }
  }

// Convertir la structure de donnée <Map, List<Tasks> en une string pour pouvoir ensuite la stocker
  String convertTasksJson(Map<DateTime, List<Task>> tasks) {
    Map<String, dynamic> jsonTasks = {};
    tasks.forEach((key, value) {
      // Pour chaque tâche convertit DateTime to string et la lsite de tâche en json
      jsonTasks[key.toString()] = value.map((task) => task.toJson()).toList();
    });
    // return la structure de donnée en json
    return jsonEncode(jsonTasks);
  }

// Convertir le l'objet JSON en structure de donnée  <Map, List<Tasks> pour qu'elle soit récupérable
  Map<DateTime, List<Task>> convertTasksMap(String tasksJson) {
    Map<String, dynamic> jsonTasks = jsonDecode(tasksJson);
    Map<DateTime, List<Task>> originalTypeTasks = {};
    jsonTasks.forEach((key, value) {
      // Convertir la clef en type DateTime
      DateTime dateTimeKey = DateTime.parse(key);
      // Pour chaque valeur de value convertir en format tache pour créer la lsite associé à la clef
      List<Task> taskList =
          (value as List).map((taskJson) => Task.fromJson(taskJson)).toList();
      originalTypeTasks[dateTimeKey] = taskList;
    });
    return originalTypeTasks;
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

// Envoi des taches au serveur d'exemple
  void sendTaskToServer() async {
    var tasksSend = getAllTask();
    try {
      // Appel du service
      Response response = await await Api().sendTasks(tasksSend);
      print(response);
    } on DioException catch (e) {
      print(e.response!.data);
    }
  }

// Récupère la liste de tâche d'un jour
  List<Task> getTaskByDay(DateTime day) {
    return tasks[day] ?? [];
  }
}
