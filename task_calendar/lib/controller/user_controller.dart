import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_calendar/controller/services/api.dart';
import 'package:task_calendar/model/user.dart';

class UserController {
  User admin = User("admin", "admin", "admin");
  Api api = Api();

// Supprime toutes les tâcges des SharedPreferences
  clearStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

// Utilise le service de connection avec un user local
  Future<void> connectUser() async {
    try {
      // Connexion au service avec les données utilisateur
      Response response = await api.login(admin.email, admin.password);
      print(response);
    } on DioException catch (e) {
      print(e.response!.data);
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // simulation de key de user connected
    prefs.setBool("user", true);
  }
}
