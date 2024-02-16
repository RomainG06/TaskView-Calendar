import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:task_calendar/controller/services/notification.dart';
import 'package:task_calendar/controller/task_controller.dart';
import 'package:task_calendar/model/task.dart';
import 'package:task_calendar/theme.dart';
import 'package:task_calendar/view/dashboard.dart';

class AddTaskView extends StatefulWidget {
  const AddTaskView(
      {super.key,
      required this.datetime,
      required this.selectedTasks,
      required this.controller});
  final DateTime datetime;
  final ValueNotifier<List<Task>> selectedTasks;
  final TaskController controller;

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  String start = "";
  String end = "";
  bool notification = false;
  DateTime scheduleTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        scrollable: true,
        title: const Text('Créer tâche!'),
        content: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Titre'),
                  controller: titleController,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  controller: descriptionController,
                ),
                ElevatedButton(
                  onPressed: () {
                    DatePicker.showTimePicker(context,
                        showTitleActions: true,
                        onChanged: (date) => scheduleTime = date,
                        onConfirm: (time) {
                          setState(() {
                            start = widget.controller.parseDateHour(time);
                          });
                        },
                        locale: LocaleType.fr);
                  },
                  child: Text(
                    start == "" ? "Début" : start,
                    style: date,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    DatePicker.showTimePicker(context, showTitleActions: true,
                        onChanged: (date) {
                      date.timeZoneOffset.inHours.toString();
                    }, onConfirm: (time) {
                      setState(() {
                        end = widget.controller.parseDateHour(time);
                      });
                    }, locale: LocaleType.fr);
                  },
                  child: Text(
                    end == "" ? "Fin" : end,
                    style: date,
                  ),
                ),
                CheckboxListTile(
                  title: const Text('Notification'),
                  value: notification,
                  onChanged: (value) {
                    setState(() {
                      notification = value!;
                    });
                  },
                ),
                ElevatedButton(
                    child: const Text("Ajouter"),
                    onPressed: () {
                      setState(() {
                        // Vérifie si les notifications sont activées sur la tache pour scheduler
                        if (notification == true && start.isNotEmpty) {
                          debugPrint(
                              'Notification Scheduled for $scheduleTime');
                          NotificationService().scheduleNotification(
                              title: 'Tache notification',
                              body: '$scheduleTime',
                              scheduledNotificationDateTime: scheduleTime);
                        }

                        // Verifie si la journée existe dans la Map si ou ajoute une tache dans la liste associé
                        if (widget.controller.tasks
                            .containsKey(widget.datetime)) {
                          widget.controller.tasks[widget.datetime]!.add(Task(
                            title: titleController.text,
                            description: descriptionController.text,
                            start: start,
                            end: end,
                            date: widget.datetime,
                            isNotification: false,
                          ));
                          // Si la journée n'existe pas dans la map, créer une nouvelle entrée avec une liste contenant la nouvelle tâche.
                        } else {
                          widget.controller.tasks[widget.datetime] = [
                            Task(
                              title: titleController.text,
                              description: descriptionController.text,
                              start: start,
                              end: end,
                              date: widget.datetime,
                              isNotification: notification,
                            )
                          ];
                        }

                        /* NotificationService().showNotification(
                            title: titleController.text, body: 'Ajouté!'); */

                        widget.controller.storeTasks();
                        /* widget.selectedTasks.value =
                            widget.controller.getTaskByDay(widget.datetime); */
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const BottomNavBarWidget(),
                          ),
                        );
                      });
                    })
              ],
            )));
  }
}
