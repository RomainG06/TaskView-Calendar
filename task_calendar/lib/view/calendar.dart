import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task_calendar/controller/task_controller.dart';
import 'package:task_calendar/model/task.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  TaskController controller = TaskController();

  @override
  void initState() {
    super.initState();
    setState(() {
      controller.loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TableCalendar(
        focusedDay: DateTime.now(),
        firstDay: DateTime.utc(2023, 09, 01),
        lastDay: DateTime.utc(2030, 1, 01),
        locale: ("fr_FR"),
        calendarFormat: CalendarFormat.month,
        headerStyle: const HeaderStyle(formatButtonVisible: false),
      ),
      const SizedBox(
        height: 8,
      ),
      controller.tasks.isNotEmpty
          ? Container(
              height: MediaQuery.of(context).size.height / 2.5,
              child: Center(
                child: ListView.builder(
                  itemCount: controller.tasks.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(controller.tasks[index].title),
                      subtitle: Text(controller.tasks[index].description),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          /* deleteTask(controller.myTaskList[index]); */
                        },
                      ),
                      /* onTap: () => goToDetails(controller.myTaskList[index]), */
                    );
                  },
                ),
              ),
            )
          : Container()
    ]);
  }
}
