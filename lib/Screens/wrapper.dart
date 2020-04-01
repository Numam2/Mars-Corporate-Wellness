import 'package:flutter/material.dart';
import 'package:personal_trainer/Screens/Authenticate/authenticate.dart';
import 'package:personal_trainer/Models/user.dart';
import 'package:personal_trainer/Screens/Home/Inicio_Navigate.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    print (user);
    
    //Return either home or authenticate widget
    if (user == null){
      return Authenticate();
    } else{
      return InicioNew();
    }
  }
}