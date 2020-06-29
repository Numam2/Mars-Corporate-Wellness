import 'package:flutter/material.dart';
import 'package:personal_trainer/Screens/Home/Inicio_Navigate.dart';
import 'package:personal_trainer/Shared/SharePrompt.dart';

class ReconitionLevelUp extends StatelessWidget {

  final String level;
  final int points;
  final String headline;
  final String time;
  ReconitionLevelUp({this.level, this.points, this.headline, this.time});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration:BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/ludus-health-coach.appspot.com/o/App%20Images%2FRecognition%20Confetti.jpg?alt=media&token=af98cffd-d1bf-47b8-8fe6-9560ea8273ee'),
            fit: BoxFit.cover,
          ) 
        ),        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ///Imgae
            Container(
              height: 200,
              child: Image(
                  image: NetworkImage(
                      'https://firebasestorage.googleapis.com/v0/b/ludus-health-coach.appspot.com/o/App%20Images%2FRecognition%20Star.png?alt=media&token=70378ac4-8954-420d-a884-eeaa134454cd')),
            ),
            SizedBox(height: 20),

            ///Message
            Text('¡Subiste de Nivel!', style: Theme.of(context).textTheme.title),
            SizedBox(height: 10),

            ///Body
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Text(
                'Alcanzaste el $level con $points puntos',
                style: Theme.of(context).textTheme.display1,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 50),

            ///Go home Button
            Container(
              height: 35.0,
              child: RaisedButton(
                onPressed: () {                 
                  return showDialog(
                    context: context,
                      builder: (context) {
                        return SharePrompt(
                          type: 'Level Up',
                          headline: 'Alcancé el $level con $points puntos',
                          time: time,
                          activityIcon: Icons.trending_up,
                        );
                      });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).accentColor,
                        Theme.of(context).primaryColor
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Container(
                    constraints:
                        BoxConstraints(maxWidth: 200.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Text("COMPARTIR",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.button),
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),

            ///Share button
            FlatButton(
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => InicioNew()));
              },
              child: Text("Ir a mi página principal",
                style: Theme.of(context).textTheme.body1,
              )
            ),

          ],
        ),
      ),
    );
  }
}
