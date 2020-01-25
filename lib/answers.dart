import 'package:flutter/material.dart';


class Respuestas extends StatelessWidget {

final Function answerText;
final String textoderespuesta;

Respuestas(this.answerText, this.textoderespuesta);

  @override
  Widget build(BuildContext context) {
    return Container(
      
      width: double.infinity,
      margin: EdgeInsets.all(10),
      
      child: RaisedButton (
        color: Colors.black,
        child: Text(
          textoderespuesta,
          style: TextStyle(color: Colors.white),
          ), 
        onPressed: answerText,
        ),
    );
  }
}