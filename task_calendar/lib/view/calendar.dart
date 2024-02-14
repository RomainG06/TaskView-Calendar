import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task_calendar/controller/task_controller.dart';
import 'package:task_calendar/model/task.dart';
import 'package:task_calendar/theme.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  // peut être mettre dans le controller
  Map<DateTime, List<Task>> tasks = {};
  late final ValueNotifier<List<Task>> _selectedTasks;
  TaskController controller = TaskController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedDay = _focusedDay;
      _selectedTasks = ValueNotifier(getTaskByDay(_selectedDay!));
    });
  }

// Méthode permettant de changer le jour selectionné avec le jour selectionné sur le calendrier
  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (_selectedDay != selectedDay) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedTasks.value = getTaskByDay(selectedDay);
      });
    }
  }

  List<Task> getTaskByDay(DateTime day) {
    return tasks[day] ?? [];
  }

  Future<void> addTask(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              scrollable: true,
              title: const Text('Ajouter une tâche!'),
              content: Container(
                  padding: EdgeInsets.all(8),
                  child: ElevatedButton(
                      child: Text("Creer tache"),
                      onPressed: () {
                        setState(() {
                          tasks.addAll({
                            _selectedDay!: [
                              Task(
                                  title: "Tache test",
                                  description: "Test",
                                  start: DateTime.now(),
                                  end: DateTime.now(),
                                  date: DateTime.now(),
                                  isNotification: false)
                            ]
                          });
                        });
                      })));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTask(context);
        },
        child: Icon(Icons.add),
      ),
      body: Column(children: [
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
          eventLoader: getTaskByDay,
        ),
        const SizedBox(
          height: 8,
        ),
        Center(child: Text(controller.parseDateDay(_selectedDay!))),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          child: ValueListenableBuilder<List<Task>>(
            valueListenable: _selectedTasks,
            builder: (context, value, child) {
              return ListView.builder(
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text(
                        "Commence: ${controller.parseDateHour(value[index].start)} \n Termine : ${controller.parseDateHour(value[index].end)}"),
                    title: Text(value[index].title),
                    subtitle: Text(value[index].description),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {},
                    ),
                  );
                },
              );
            },
          ),
        )
      ]),
    );
  }
}
