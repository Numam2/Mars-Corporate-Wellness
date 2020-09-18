import 'package:flutter/material.dart';
import 'package:personal_trainer/Screens/Authenticate/SignIn.dart';
import 'package:personal_trainer/Screens/Authenticate/register.dart';

class Authenticate extends StatefulWidget {


  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

bool showSignIn = true;

void toggleView (){
  setState(() => showSignIn = !showSignIn);
}

  @override
  Widget build(BuildContext context) {
    if (showSignIn){
      return SignIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}
