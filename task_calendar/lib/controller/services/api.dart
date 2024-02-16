import 'package:dio/dio.dart';
import 'package:task_calendar/model/task.dart';

class Api {
  String endpoint = "https://example.com/api";
  final dio = Dio();

// Exemple de service de Login classque avec email et password en parametre
  Future<Response> login(String email, String password) async {
    try {
      Response response = await dio.post(
        "$endpoint/login/",
        // Envoi des données au format JSON
        data: {'email': email, 'password': password},
      );
      //Si l'API est valide récupère le résultat ici
      return response.data;
      // Gestion d'exception avec le retour d'erreur
    } on DioException catch (e) {
      print(e.response!.data);
      return e.response!.data;
    }
  }

  // Méthode pour envoyer une liste de tâches au format JSON
  Future<dynamic> sendTasks(List<Task> tasks) async {
    try {
      Response response = await dio.post(
        "$endpoint/todo/",
        // Pour chaque élément de la liste convertit une tache en format JSON
        data: tasks.map((task) => task.toJson()).toList(),
      );
      return response.data;
    } on DioException catch (e) {
      print(e.response?.data);
      throw e.response?.data;
    }
  }

  // Méthode pour inscrire un utilisateur
  Future<dynamic> signUpUser(
      String username, String email, String password) async {
    try {
      Response response = await dio.post(
        "$endpoint/signup/",
        // ! à la différence de login ici il faut envoyer dans data TOUT les champs relatifs à un User !
        data: {
          'name': username,
          'email': email,
          'password': password,
        },
      );
      return response.data;
    } on DioException catch (e) {
      print(e.response?.data);
      throw e.response?.data;
    }
  }
}
