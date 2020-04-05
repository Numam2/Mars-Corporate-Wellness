import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Profile/MissingProfile.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final _profile = Provider.of<UserProfile>(context);

    if (_profile == null) {
      return Center(child: Loading());
    } else if (_profile.preference == "None" || _profile.preference == "") {
      MissingProfile();
    }

    return Scaffold(
      body: Container(
        //color: Colors.red,
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //Green Container with Name and Data
            Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.blueGrey.shade900,
                  boxShadow: <BoxShadow>[
                    new BoxShadow(
                      color: Colors.black12,
                      offset: new Offset(5.0, 10.0),
                      blurRadius: 10.0,
                    )
                  ]),
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //Name
                      Container(
                        child: Text(
                          'Hi ' + _profile.name + '!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                              fontSize: 35.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 40),
                      //Age-weight,height
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ///Age
                          Column(
                            children: <Widget>[
                              Text(
                                _profile.age,
                                style: GoogleFonts.montserrat(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Age',
                                style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w200,
                                    color: Colors.white),
                              )
                            ],
                          ),
                          SizedBox(width: 50),

                          ///Height
                          Column(
                            children: <Widget>[
                              Text(
                                _profile.height,
                                style: GoogleFonts.montserrat(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Cm',
                                style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w200,
                                    color: Colors.white),
                              )
                            ],
                          ),
                          SizedBox(width: 50),

                          ///Weight
                          Column(
                            children: <Widget>[
                              Text(
                                _profile.weight,
                                style: GoogleFonts.montserrat(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Kg',
                                style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w200,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ],
                      )
                    ]),
              ),
            ),
            //Goal and experience
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
              child: Container(
                height: 80,
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    _profile.experience + " and I want to " + _profile.goal,
                    style: GoogleFonts.montserrat(
                        fontStyle: FontStyle.italic, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            //Metrics
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ///Workouts
                  Container(
                    width: 110,
                    //height: 110,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: <BoxShadow>[
                          new BoxShadow(
                            color: Colors.black12,
                            offset: new Offset(0.0, 10.0),
                            blurRadius: 10.0,
                          )
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Icon(
                            Icons.check,
                            size: 20,
                            color: Colors.redAccent[700],
                            //Icons.whatshot
                          ),
                        ),
                        SizedBox(height: 7),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              _profile.accumulatedWorkouts.toString(),
                              style: GoogleFonts.montserrat(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Workouts',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                  wordSpacing: 30),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 15),

                  ///Hours
                  Container(
                    width: 110,
                    //height: 110,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: <BoxShadow>[
                          new BoxShadow(
                            color: Colors.black12,
                            offset: new Offset(0.0, 10.0),
                            blurRadius: 10.0,
                          )
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Icon(
                            Icons.access_time,
                            size: 20,
                            color: Colors.redAccent[700],
                          ),
                        ),
                        SizedBox(height: 7),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              _profile.accumulatedHours.toString(),
                              style: GoogleFonts.montserrat(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Hours',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                  wordSpacing: 30),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 15),

                  ///Calories
                  Container(
                    width: 110,
                    //height: 110,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: <BoxShadow>[
                          new BoxShadow(
                            color: Colors.black12,
                            offset: new Offset(0.0, 10.0),
                            blurRadius: 10.0,
                          )
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Icon(
                            Icons.whatshot,
                            size: 20,
                            color: Colors.redAccent[700],
                            //Icons.whatshot
                          ),
                        ),
                        SizedBox(height: 7),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              _profile.caloriesBurnt.toString(),
                              style: GoogleFonts.montserrat(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Calories',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                  wordSpacing: 30),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
