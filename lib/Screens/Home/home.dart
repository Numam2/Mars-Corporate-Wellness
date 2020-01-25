import 'package:flutter/material.dart';
import 'package:personal_trainer/Firebase_Services/auth.dart';
import 'package:personal_trainer/questions.dart';
import 'package:personal_trainer/answers.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

final AuthService _auth = AuthService();

var numberofquestion = 0;

void answerQ(){
   setState((){
    numberofquestion = numberofquestion + 1;
   });
}

  @override
  Widget build(BuildContext context) {

    var questions = [
      {"Texto" : "Cual es tu ejercicio favorito?", "Respuestass" : ["Squats","Cleans","Jerks","Swings"]},
      {"Texto" : "Cual es tu dia favorito?", "Respuestass" : ["Lunes","Martes","Sabado"]},
      {"Texto" : "Cual es tu musica preferida?", "Respuestass" : ["Rock","Pock","Hic Hok","Jass","Tango"]},
    ];

    return Scaffold(

          //Appbar
          appBar: AppBar(
            backgroundColor: Colors.blueGrey.shade900,
            title: Text("Loom Coach"),
            actions: <Widget>[
              FlatButton.icon(
                icon: Icon(
                  Icons.person,
                   color: Colors.white,),
                label: Text(
                  "Log out",
                   style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  await _auth.signOut();
                },
              )
            ],
          ),

          //Body
          body: Column(
            children: [
              Preguntas(questions[numberofquestion]["Texto"]),
              ...(questions[numberofquestion]["Respuestass"] as List<String>).map((answer){
                return Respuestas(answerQ,answer);
              }).toList()
            ],
          ),
    );
  }
}

