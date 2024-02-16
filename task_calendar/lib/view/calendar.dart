import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:task_calendar/controller/services/notification.dart';
import 'package:task_calendar/controller/task_controller.dart';
import 'package:task_calendar/model/task.dart';
import 'package:task_calendar/theme.dart';
import 'package:task_calendar/view/task.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late final ValueNotifier<List<Task>> _selectedTasks;
  TaskController controller = TaskController();

  @override
  void initState() {
    // Charge les tâche à l'initialisation
    _selectedDay = _focusedDay;
    _selectedTasks = ValueNotifier(controller.getTaskByDay(_selectedDay!));
    super.initState();
  }

// Méthode permettant de changer le jour selectionné avec le jour selectionné sur le calendrier
  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, focusedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedTasks.value = controller.getTaskByDay(selectedDay);
      });
    }
  }

  Future<void> initAllTasks() async {
    await controller.loadTasks();
    _selectedTasks.value = controller.getTaskByDay(_selectedDay!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog<void>(
              context: context,
              builder: ((context) => AddTaskView(
                    datetime: _selectedDay!,
                    selectedTasks: _selectedTasks,
                    controller: controller,
                  )));
        },
        backgroundColor: amberCustom,
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        // Création du FutureBuilder pour mettre à jour le calendrier lorque les tâches sont initialisées
        child: FutureBuilder(
            future: initAllTasks(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              return Column(children: [
                TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime.utc(2023, 09, 01),
                  lastDay: DateTime.utc(2030, 1, 01),
                  calendarStyle: const CalendarStyle(
                      todayDecoration: BoxDecoration(
                          color: Color.fromARGB(127, 255, 193, 7),
                          shape: BoxShape.circle),
                      selectedDecoration: BoxDecoration(
                          color: amberCustom, shape: BoxShape.circle)),
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: onDaySelected,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  locale: ("fr_FR"),
                  calendarFormat: CalendarFormat.month,
                  headerStyle: const HeaderStyle(formatButtonVisible: false),
                  eventLoader: controller.getTaskByDay,
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                Center(
                    child: Text(
                  controller.parseDateDay(_selectedDay!),
                  style: const TextStyle(color: amberCustom),
                )),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: controller.getTaskByDay(_selectedDay!).isNotEmpty
                      ? ValueListenableBuilder<List<Task>>(
                          valueListenable: _selectedTasks,
                          builder: (context, value, child) {
                            return ListView.builder(
                              itemCount: value.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 0.5,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: ListTile(
                                        leading: value[index].start.isNotEmpty
                                            ? Text(
                                                "start: ${value[index].start}",
                                                style: date,
                                              )
                                            : const Text(""),
                                        title: Center(
                                          child: Text(
                                            value[index].title,
                                            style: const TextStyle(
                                                color: amberCustom,
                                                fontSize: 25),
                                          ),
                                        ),
                                        subtitle: Center(
                                          child: Text(
                                            value[index].description,
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        trailing: value[index].end.isNotEmpty
                                            ? Text(
                                                "end : ${value[index].end}",
                                                style: date,
                                              )
                                            : const Text("")),
                                  ),
                                );
                              },
                            );
                          },
                        )
                      : const Center(
                          child: Text(
                              "Vous n'avez pas de tâches sur cette journée")),
                )
              ]);
            }),
      ),
    );
  }

  Future<void> addTask(BuildContext context) {
    /* late String title;
    late String description;
    String start = "";
    String end = "";
    late DateTime _date;
    bool notification = false; */
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return ADDDDDD(); /* AlertDialog(
              scrollable: true,
              title: const Text('Créer tâche!'),
              content: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      TextField(
                        decoration: const InputDecoration(labelText: 'Titre'),
                        controller: TextEditingController(),
                        onChanged: (value) {
                          title = value;
                        },
                      ),
                      TextField(
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        controller: TextEditingController(),
                        onChanged: (value) {
                          description = value;
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          DatePicker.showTimePicker(context,
                              showTitleActions: true, onChanged: (date) {
                            date.timeZoneOffset.inHours.toString();
                          }, onConfirm: (time) {
                            setState(() {
                              start = controller.parseDateHour(time);
                            });
                          }, locale: LocaleType.fr);
                        },
                        child: Text(start == "" ? "Début" : start),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          DatePicker.showTimePicker(context,
                              showTitleActions: true, onChanged: (date) {
                            date.timeZoneOffset.inHours.toString();
                          }, onConfirm: (time) {
                            end = controller.parseDateHour(time);
                          }, locale: LocaleType.fr);
                        },
                        child: const Text("Fin"),
                      ),
                      CheckboxListTile(
                        title: Text('Notification'),
                        value: notification,
                        onChanged: (value) {
                          setState(() {
                            notification = value!;
                          });
                        },
                      ),
                      ElevatedButton(
                          child: Text("Ajouter"),
                          onPressed: () {
                            setState(() {
                              NotificationService().showNotification(
                                  title: 'Tache1', body: 'Ajouté!');
                              if (controller.tasks.containsKey(_selectedDay)) {
                                controller.tasks[_selectedDay]!.add(Task(
                                  title: "title",
                                  description: "description",
                                  start: "start",
                                  end: "end",
                                  date: _selectedDay!,
                                  isNotification: notification,
                                ));
                              } else {
                                controller.tasks[_selectedDay!] = [
                                  Task(
                                    title: "title",
                                    description: "description",
                                    start: "start",
                                    end: "end",
                                    date: _selectedDay!,
                                    isNotification: notification,
                                  )
                                ];
                              }
                              _selectedTasks.value =
                                  controller.getTaskByDay(_selectedDay!);
                              controller.storeTasks();
                            });
                          }),
                    ],
                  ))); */
        });
  }

  AlertDialog ADDDDDD() {
    TextEditingController? titleController;
    TextEditingController? descriptionController;
    String start = "";
    String end = "";
    bool notification = false;
    DateTime scheduleTime = DateTime.now();
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
                            start = controller.parseDateHour(time);
                          });
                        },
                        locale: LocaleType.fr);
                  },
                  child: Text(start == "" ? "Début" : start),
                ),
                ElevatedButton(
                  onPressed: () {
                    DatePicker.showTimePicker(context, showTitleActions: true,
                        onChanged: (date) {
                      date.timeZoneOffset.inHours.toString();
                    }, onConfirm: (time) {
                      setState(() {
                        end = controller.parseDateHour(time);
                      });
                    }, locale: LocaleType.fr);
                  },
                  child: Text(end == "" ? "Fin" : end),
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
                        if (controller.tasks.containsKey(_selectedDay)) {
                          controller.tasks[_selectedDay]!.add(Task(
                            title: titleController!.text,
                            description: descriptionController!.text,
                            start: start,
                            end: end,
                            date: _selectedDay!,
                            isNotification: false,
                          ));
                          // Si la journée n'existe pas dans la map, créer une nouvelle entrée avec une liste contenant la nouvelle tâche.
                        } else {
                          controller.tasks[_selectedDay!] = [
                            Task(
                              title: titleController!.text,
                              description: descriptionController!.text,
                              start: start,
                              end: end,
                              date: _selectedDay!,
                              isNotification: notification,
                            )
                          ];
                        }

                        /* NotificationService().showNotification(
                            title: titleController.text, body: 'Ajouté!'); */

                        controller.storeTasks();
                        _selectedTasks.value = controller.getTaskByDay(
                          _selectedDay!,
                        );

                        Navigator.pop(context);
                      });
                    })
              ],
            )));
  }
}
