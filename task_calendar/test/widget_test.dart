// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_calendar/controller/task_controller.dart';
import 'package:task_calendar/view/task.dart';

void main() {
  testWidgets('AddTaskView test', (WidgetTester tester) async {
    TaskController controllerTest = TaskController();
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
        home: AddTaskView(
      datetime: DateTime.now(),
      controller: controllerTest,
    )));

    // Verifie que le Widget initialise les TextController
    expect(find.byType(TextField), findsNWidgets(2));

    // Test UI elements
    expect(find.text('Ajoutez votre tâche'), findsOneWidget);
    expect(find.text('Titre'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNWidgets(3));
    expect(find.byType(CheckboxListTile), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    //await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
  });
}
