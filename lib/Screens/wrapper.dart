import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_trainer/Screens/Authenticate/authenticate.dart';
import 'package:personal_trainer/Screens/Home/Inicio_Navigate.dart';
import 'package:personal_trainer/Shared/Loading.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return Authenticate();
          }
          return InicioNew();
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Loading(),
            ),
          );
        }
      },
    );

  }
}