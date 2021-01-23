import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/weeks.dart';
import 'package:personal_trainer/Models/workout.dart';
import 'package:personal_trainer/Screens/Home/Inicio_Navigate.dart';
import 'package:personal_trainer/Screens/Workouts/WorkoutPage.dart';
import 'package:personal_trainer/Shared/WorkoutStopwatch.dart';
import 'package:provider/provider.dart';
import 'package:screen/screen.dart';

class DailyWorkout extends StatefulWidget {

  final String collection;
  final String day;
  final String weekNo;
  final String id;
  final String uid;

  final List<String> exerciseVideoList;
  final List exerciseList;

  DailyWorkout({this.collection, this.day, this.weekNo, this.id , this.exerciseVideoList, this.exerciseList, this.uid});

  @override
  _DailyWorkoutState createState() => _DailyWorkoutState();
}

class _DailyWorkoutState extends State<DailyWorkout> {

  final pageController = PageController(initialPage: 0);

  @override
  void initState() {
    Screen.keepOn(true);
    super.initState();
  }

  /// UI Widget 
  @override
  Widget build(BuildContext context) {    
    
    return MultiProvider(
      providers:[
        StreamProvider<List<Workout>>.value(value: DatabaseService().dayWorkout(widget.collection, widget.id, widget.weekNo, widget.day)),
        StreamProvider<WeekDays>.value(value: DatabaseService().trainingDayDetails(widget.collection, widget.id, widget.weekNo, widget.day)),
      ],
      child: WillPopScope(
        onWillPop:() => showDialog(
          context: context,
          builder: (context){
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              child: Container(
                height: 250,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment(1.0, 0.0),
                        child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.close),
                            iconSize: 20.0),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 5),
                        child: Text(
                          "Si sales ahora no se guardará el entrenamiento ¿Quieres salir?",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                                                
                            Container(
                              height: 35.0,
                              width: 100,
                              child: RaisedButton(
                                onPressed: () async {
                                   Navigator.of(context).pushAndRemoveUntil(
                                     MaterialPageRoute(builder: (context) => InicioNew()), (Route<dynamic> route) => false);
                                  
                                  await DefaultCacheManager().emptyCache();
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                padding: EdgeInsets.all(0.0),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).accentColor,
                                    border: Border.all(color: Theme.of(context).accentColor, width: 0.8),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 200.0, minHeight: 50.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "SI",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: 20),

                            Container(
                              height: 35.0,
                              width: 100,
                              child: RaisedButton(
                                onPressed: () => Navigator.pop(context),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                padding: EdgeInsets.all(0.0),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).accentColor,
                                    border: Border.all(color: Theme.of(context).accentColor, width: 0.8),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 200.0, minHeight: 50.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "NO",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        ),
        child: SafeArea(
          child: Scaffold(

            body: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom:75.0),
                  child: WorkoutPage(day: widget.day, exerciseVideoList: widget.exerciseVideoList, pageController: pageController),
                ),

                StopwatchButton(
                  trainingRoutine: (widget.id == widget.uid) ? 'My Routine': widget.id,
                  currentDay: widget.day ?? '', 
                  currentWeek: widget.weekNo ?? '', 
                  pageController: pageController
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
