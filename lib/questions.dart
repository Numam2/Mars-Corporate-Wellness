
import 'package:flutter/material.dart';

class Preguntas extends StatelessWidget {

final String preguntaText;

Preguntas(this.preguntaText);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(20),
      child: Text(
        preguntaText,
        style: TextStyle(fontSize: 25),
        textAlign: TextAlign.center,
        
      ),
    );
  }
}