import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/Recipes.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Home/SavedRecipesHome.dart';
import 'package:personal_trainer/Screens/Profile/ActivityLogBox.dart';
import 'package:personal_trainer/Screens/Profile/EditProfile.dart';
import 'package:personal_trainer/Screens/Profile/ProgressPicBox.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'MissingProfile.dart';
import 'package:intl/intl.dart';

class ProfileContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final _profile = Provider.of<UserProfile>(context);

    if (_profile == null) {
      return Center(child: Loading());
    } else if (_profile.preference == "None" || _profile.preference == "") {
      MissingProfile();
    }

    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //Green Container with Name and Data
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularStepProgressIndicator(
                      totalSteps: _profile.levelTo - _profile.levelFrom,
                      currentStep: _profile.points - _profile.levelFrom,
                      selectedColor: Theme.of(context).accentColor,
                      selectedStepSize: 6,
                      unselectedStepSize: 4,
                      unselectedColor:
                          Theme.of(context).disabledColor.withOpacity(0.2),
                      padding: 0,
                      width: 120,
                      height: 120,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditProfile(profile: _profile)));
                          },
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey[100],
                            child: ClipOval(
                              child: Container(
                                  height: 120,
                                  width: 120,
                                  child: Image.network(_profile.profilePic,
                                      fit: BoxFit.cover)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

                    //Name
                    Container(
                      child: Text(
                        _profile.name,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 10),

                    //Level
                    Container(
                      child: Text(
                        _profile.level,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 5),

                    //Level Points
                    Container(
                      child: Text(
                        _profile.points.toString() +
                            ' / ' +
                            (_profile.levelTo + 1).toString() +
                            ' pts',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                    ),
                  ]),
            ),
          ),

          //Metrics
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 20),
            child: Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ///Workouts
                  Container(
                    width: MediaQuery.of(context).size.width * 0.27,
                    //height: 110,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: <BoxShadow>[
                          new BoxShadow(
                            color: Colors.grey[350],
                            offset: new Offset(0.0, 3.0),
                            blurRadius: 5.0,
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
                            color: Theme.of(context).primaryColor,
                            //Icons.whatshot
                          ),
                        ),
                        SizedBox(height: 7),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              NumberFormat.compact()
                                  .format(_profile.accumulatedWorkouts)
                                  .toString(),
                              style: GoogleFonts.montserrat(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Sesiones',
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
                    width: MediaQuery.of(context).size.width * 0.27,
                    //height: 110,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: <BoxShadow>[
                          new BoxShadow(
                            color: Colors.grey[350],
                            offset: new Offset(0.0, 3.0),
                            blurRadius: 5.0,
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
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 7),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              NumberFormat.compact()
                                  .format(_profile.accumulatedHours)
                                  .toString(),
                              style: GoogleFonts.montserrat(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Horas',
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
                    width: MediaQuery.of(context).size.width * 0.27,
                    //height: 110,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: <BoxShadow>[
                          new BoxShadow(
                            color: Colors.grey[350],
                            offset: new Offset(0.0, 3.0),
                            blurRadius: 5.0,
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
                            color: Theme.of(context).primaryColor,
                            //Icons.whatshot
                          ),
                        ),
                        SizedBox(height: 7),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              NumberFormat.compact()
                                  .format(_profile.caloriesBurnt)
                                  .toString(),
                              style: GoogleFonts.montserrat(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Calorías',
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
            ),
          ),
          SizedBox(height: 20),

          //Activity Timeline          
          StreamProvider<UserActivityList>.value(
              value: DatabaseService().activityLog, child: ActivityLogBox()),
          SizedBox(height: 30),

          //My progress pics
          ProgressPicBox(),
          SizedBox(height: 40),

          //My saved Recipes          
          StreamProvider<List<Recipes>>.value(
            value: DatabaseService().savedRecipes,
            child: SavedRecipesHome()
          ),
          SizedBox(height:25),

        ],
      ),
    );
  }
}
