import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:task_calendar/controller/services/notification.dart';
import 'package:task_calendar/theme.dart';
import 'package:task_calendar/view/dashboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  // Utilisation du package intl pour utiliser le francais en locale, pour l'utilisation du calendrier
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: amberCustom),
        useMaterial3: true,
      ),
      home: const BottomNavBarWidget(),
    );
  }
}
