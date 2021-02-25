import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Screens/Home/Inicio_Navigate.dart';
import 'package:personal_trainer/Screens/Social/CreatePost.dart';

class ReconitionHabitChallenge extends StatelessWidget {

  final String headline;
  final String time;
  final String organization;
  ReconitionHabitChallenge({this.headline, this.time, this.organization});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ///Imgae
            Container(
              height: 200,
              child: Image(
                  image: AssetImage(
                      'Images/App Pics/iconos ilust-14.png')),
            ),
            SizedBox(height: 20),

            ///Message
            Text('¡Excelente Trabajo!', style: Theme.of(context).textTheme.title),
            SizedBox(height: 10),

            ///Body
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Text(
                'Te propusiste adoptar un nuevo hábito y lograste mantenerlo en el tiempo establecido. Pero esto no termina aca, ahora demuestra que puedes sostenerlo a largo plazo. Sigue así',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,                  
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 50),

            ///Go home Button
            Container(
              height: 35.0,
              child: RaisedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreatePost(
                    groupName: organization,
                    type: 'Challenge completed',
                    headline: headline,
                    time: time,
                    activityIcon: Icons.fitness_center
                  )));
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
