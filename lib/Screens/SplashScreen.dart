import 'dart:async';

import 'package:flutter/material.dart';
import 'package:personal_trainer/Screens/wrapper.dart';

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

@override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => Wrapper()));});
  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
          body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Center(
          child: Container(
            height: 250,
            child: Image(            
              image: AssetImage('Images/Brand/SplashScreen Logo.png'),
              fit: BoxFit.fitHeight,              
            ),
          )
        ),
      ),
    );
  }
}