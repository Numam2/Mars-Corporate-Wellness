import 'package:flutter/material.dart';
import 'package:personal_trainer/Firebase_Services/auth.dart';
import 'package:personal_trainer/Screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:personal_trainer/Models/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}



class _MyAppState extends State<MyApp> {
  
  @override
  Widget build(BuildContext context) {

    return StreamProvider<User>.value(

      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}




















//Couse Flutter Code

//import './questions.dart';
//import './answers.dart';

//void main() {
  //runApp(MyApp());
//}

//class MyApp extends StatefulWidget {

  //@override
  //_MyAppState createState() => _MyAppState();
//}



//class _MyAppState extends State<MyApp> {
  //var numberofquestion = 0;

//void answerQ(){
  // setState((){
    //numberofquestion = numberofquestion + 1;
   //});
//}
 
  //@override
  //Widget build(BuildContext context) {

    //var questions = [
     // {"Texto" : "Cual es tu ejercicio favorito?", "Respuestass" : ["Squats","Cleans","Jerks","Swings"]},
      //{"Texto" : "Cual es tu dia favorito?", "Respuestass" : ["Lunes","Martes","Sabado"]},
      //{"Texto" : "Cual es tu musica preferida?", "Respuestass" : ["Rock","Pock","Hic Hok","Jass","Tango"]},
    //];

    //return MaterialApp(
      //home: Scaffold(
          //appBar: AppBar(
            //title: Text("Ludus Coach"),
          //),
          //body: Column(
            //children: [
              //Preguntas(questions[numberofquestion]["Texto"]),

              //...(questions[numberofquestion]["Respuestass"] as List<String>).map((answer){
                //return Respuestas(answerQ,answer);
              //}).toList()
            //],
          //)),
    //);
  //}
//}