import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Screens/Home/Inicio_Navigate.dart';
import 'package:personal_trainer/Screens/Social/CreatePost.dart';

class ReconitionWorkout extends StatelessWidget {

  final String headline;
  final int time;
  final int calories;
  final int points;
  final String organization;
  ReconitionWorkout({this.headline, this.time, this.calories, this.points, this.organization});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ///Imgae
            Container(              
              width: MediaQuery.of(context).size.width *0.5,
              child: Image(
                  image: AssetImage(
                      'Images/App Pics/iconos ilust-16.png')),
            ),
            SizedBox(height: 20),

            ///Message
            Text('¡Buen trabajo!', style: Theme.of(context).textTheme.title),
            SizedBox(height: 50),

            ///Body
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width*0.6
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //Calories
                    Container(
                      width: 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '$calories',
                            style: GoogleFonts.montserrat(
                              fontSize: 30, fontWeight: FontWeight.w500
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'CALS',
                            style: Theme.of(context).textTheme.body1,
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    //Time
                    Container(
                      width: 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '$time',
                            style: GoogleFonts.montserrat(
                              fontSize: 30, fontWeight: FontWeight.w500
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'MIN',
                            style: Theme.of(context).textTheme.body1,
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    //Pts
                    Container(
                      width: 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '$points',
                            style: GoogleFonts.montserrat(
                              fontSize: 30, fontWeight: FontWeight.w500
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'PTS',
                            style: Theme.of(context).textTheme.body1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ),
            SizedBox(height: 50),

            ///Go home Button
            Container(
              height: 35.0,
              child: RaisedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreatePost(
                    groupName: organization,
                    type: 'Exercise',
                    headline: headline,
                    time: time.toString() + ' MIN',
                    activityIcon: Icons.fitness_center,
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
