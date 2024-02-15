import 'dart:math';

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
    super.initState();
    setState(() {
      _selectedDay = _focusedDay;
      _selectedTasks = ValueNotifier(controller.getTaskByDay(_selectedDay!));
    });
  }

// Méthode permettant de changer le jour selectionné avec le jour selectionné sur le calendrier
  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    controller.loadTasks();
    if (!isSameDay(_selectedDay, focusedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedTasks.value = controller.getTaskByDay(selectedDay);
      });
    }
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
        child: Column(children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2023, 09, 01),
            lastDay: DateTime.utc(2030, 1, 01),
            calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                    color: Color.fromARGB(127, 255, 193, 7),
                    shape: BoxShape.circle),
                selectedDecoration:
                    BoxDecoration(color: amberCustom, shape: BoxShape.circle)),
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
                          return ListTile(
                              leading: value[index].start.isNotEmpty
                                  ? Text("start: ${value[index].start}")
                                  : const Text(""),
                              title: Center(
                                child: Text(
                                  value[index].title,
                                  style: const TextStyle(
                                      color: amberCustom, fontSize: 25),
                                ),
                              ),
                              subtitle: Center(
                                child: Text(
                                  value[index].description,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                              trailing: value[index].end.isNotEmpty
                                  ? Text("end : ${value[index].end}")
                                  : const Text(""));
                        },
                      );
                    },
                  )
                : const Center(
                    child: Text("Vous n'avez pas de tâches sur cette journée")),
          )
        ]),
      ),
    );
  }

  /*  Future<void> addTask(BuildContext context) {
    late String title;
    late String description;
    String start = "";
    String end = "";
    late DateTime _date;
    bool notification = false;
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
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
                                  title: title,
                                  description: description,
                                  start: start,
                                  end: end,
                                  date: _selectedDay!,
                                  isNotification: false,
                                ));
                              } else {
                                controller.tasks[_selectedDay!] = [
                                  Task(
                                    title: title,
                                    description: description,
                                    start: start,
                                    end: end,
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
                  )));
        });
  } */
}
