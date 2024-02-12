import 'package:flutter/material.dart';
import 'package:task_calendar/theme.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Column(children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.width * 0.4,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("lib/assets/profil.png"),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * heightMediumSpace,
            ),
            const Text(
              "Utilisateur",
              style: title,
            ),
            const Text(
              "Profil de gestion des tâches",
              style: description,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * heightMediumSpace,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.height * widthBtnProfile,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: amberCustom),
                child: const Text(
                  "Voir mes Tâches",
                  style: blackTxt,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.height * widthBtnProfile,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: amberCustom),
                child: const Text(
                  "Envoyer les tâches",
                  style: blackTxt,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
