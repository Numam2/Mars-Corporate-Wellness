import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Firebase_Services/levelTracker.dart';
import 'package:personal_trainer/Models/dates.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Shared/RecognitionLevelUp.dart';
import 'package:personal_trainer/Shared/RecognitionWorkout.dart';
import 'package:provider/provider.dart';

class FinishWorkout extends StatefulWidget {
  final int workoutMinutes;
  final int currentTrainingDayIndex;
  final int maxTrainingDayIndex;
  final String trainingRoutine;
  final String nextTrainingWeek;
  final String nextTrainingDay;
  final String nextTrainingDuration;
  final String currentTrainingDuration;
  final String currentWeek;
  final String currentDay;
  FinishWorkout({Key key, 
    this.workoutMinutes,
    this.currentTrainingDayIndex, 
    this.maxTrainingDayIndex,
    this.trainingRoutine,
    this.nextTrainingWeek, 
    this.nextTrainingDay, 
    this.nextTrainingDuration,
    this.currentTrainingDuration,
    this.currentWeek,
    this.currentDay,
  })
  
    : super(key: key);

  @override
  _FinishWorkoutState createState() => _FinishWorkoutState();
}

class _FinishWorkoutState extends State<FinishWorkout> {
  
  var firestore = FirebaseFirestore.instance;
  int workoutCounter;
  int hoursCounter;
  int caloriesFormula;
  int met = 7;
  int caloriesCounter;
  int pointsCounter;

  String trainingType;
  String trainingSession;

  ////////Total calories burned = Duration (in minutes)*(MET*3.5*weight in kg)/200
  ///MET (Metabolic Equivalent for Task) - USING 7 AS AVG  => https://sites.google.com/site/compendiumofphysicalactivities/Activity-Categories/conditioning-exercise
  ///Reference for formula https://www.verywellfit.com/how-many-calories-you-burn-during-exercise-4111064


  @override
  Widget build(BuildContext context) {

    final _profile = Provider.of<UserProfile>(context);

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
                  "¿Completaste el entrenamiento?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: 20.0,
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
                            workoutCounter = _profile.accumulatedWorkouts + 1;
                            caloriesFormula = (widget.workoutMinutes * (met * 3.5 * double.parse(_profile.weight) / 200)).round();
                            caloriesCounter = _profile.caloriesBurnt + caloriesFormula;
                            hoursCounter = (_profile.accumulatedHours + (widget.workoutMinutes / 60)).round();
                            pointsCounter = _profile.points + 25;

                            //Clean Cache Manager
                            await DefaultCacheManager().emptyCache();

                            //Record to Org Stats
                            DatabaseService().recordOrganizationStats(_profile.organization, 'Workouts Completed');
                            DatabaseService().recordOrganizationCountStats(_profile.organization, 'Workout Time in Minutes', widget.workoutMinutes);
                            DatabaseService().recordOrganizationCountStats(_profile.organization, 'Calories Burnt', caloriesFormula);

                            //If individual workout, just save activity
                            if(widget.trainingRoutine == 'Individual Workouts'){
                              trainingType = widget.currentDay;
                              trainingSession = 'Entrenamiento';
                              DatabaseService().saveTrainingSession(trainingType, widget.workoutMinutes.toString() + ' min', trainingSession);
                            } else {
                              /////Save workout to Activity Log
                              trainingType = widget.trainingRoutine;
                              trainingSession = widget.currentWeek == null ? '' : widget.currentWeek + ' - ' + widget.currentDay;
                              DatabaseService().saveTrainingSession(trainingType, widget.workoutMinutes.toString() + ' min', trainingSession);

                              /////Logic to move to next day
                              DatabaseService().updateUserWorkoutProgress(
                                widget.trainingRoutine == 'My Routine' ? true : false,
                                widget.trainingRoutine,
                                widget.nextTrainingDay,
                                widget.nextTrainingWeek,
                                widget.nextTrainingDuration,
                              );                            
                            }

                            /////Logic to record challenge updates                            
                            if(_profile.activeOrganizationChallenges == {} || _profile.activeOrganizationChallenges == null){
                              //Do nothing
                            } else {
                              if(_profile.activeOrganizationChallenges['Status'] == 'Completo' || DateTime.now().difference(_profile.activeOrganizationChallenges['Date Finish'].toDate()).inDays > 0){
                                //Do nothing
                              }
                              ///If save workout session
                              else if(_profile.activeOrganizationChallenges['Type'] ==  'Exercise Count'){
                                //If next to complete
                                if(_profile.activeOrganizationChallenges['Completed Steps'] + 1 == _profile.activeOrganizationChallenges['Target']){
                                  DatabaseService().updateOrgChallenge('Completo', _profile.activeOrganizationChallenges['Completed Steps'] + 1);
                                  DatabaseService().saveTrainingSession('Reto', DatesDictionary().monthDictionary[_profile.activeOrganizationChallenges['Date Finish'].month - 1], _profile.activeOrganizationChallenges['Challenge Title']);
                                  DatabaseService().updateChallengeCompletedCount(_profile.organization,_profile.activeOrganizationChallenges['Challenge ID']);
                                  DatabaseService().recordOrganizationStats(_profile.organization, 'Challenges Completed');
                                } else {
                                  DatabaseService().updateOrgChallenge('En Progreso', _profile.activeOrganizationChallenges['Completed Steps'] + 1);
                                }
                              }
                              ///If accumulate time trained
                              else if(_profile.activeOrganizationChallenges['Type'] ==  'Exercise Minutes Count'){
                                //If next to complete                                
                                if(_profile.activeOrganizationChallenges['Completed Steps'] + (widget.workoutMinutes / 60).round() == _profile.activeOrganizationChallenges['Target']){
                                  DatabaseService().saveTrainingSession('Reto', DatesDictionary().monthDictionary[_profile.activeOrganizationChallenges['Date Finish'].month - 1], _profile.activeOrganizationChallenges['Challenge Title']);
                                  DatabaseService().updateOrgChallenge('Completo', _profile.activeOrganizationChallenges['Completed Steps'] + (widget.workoutMinutes / 60).round());
                                  DatabaseService().updateChallengeCompletedCount(_profile.organization,_profile.activeOrganizationChallenges['Challenge ID']);
                                  DatabaseService().recordOrganizationStats(_profile.organization, 'Challenges Completed');
                                } else {
                                  DatabaseService().updateOrgChallenge('En progreso',_profile.activeOrganizationChallenges['Completed Steps'] + (widget.workoutMinutes / 60).round());
                                }
                              }
                              ///If save calories
                              else if(_profile.activeOrganizationChallenges['Type'] ==  'Calorie Count'){
                                //If next to complete
                                if(_profile.activeOrganizationChallenges['Completed Steps'] + caloriesFormula == _profile.activeOrganizationChallenges['Target']){
                                  DatabaseService().saveTrainingSession('Reto', DatesDictionary().monthDictionary[_profile.activeOrganizationChallenges['Date Finish'].month - 1], _profile.activeOrganizationChallenges['Challenge Title']);
                                  DatabaseService().updateOrgChallenge('Completo', _profile.activeOrganizationChallenges['Completed Steps'] + caloriesFormula);
                                  DatabaseService().updateChallengeCompletedCount(_profile.organization,_profile.activeOrganizationChallenges['Challenge ID']);
                                  DatabaseService().recordOrganizationStats(_profile.organization, 'Challenges Completed');
                                } else {
                                  DatabaseService().updateOrgChallenge('En progreso', _profile.activeOrganizationChallenges['Completed Steps'] + caloriesFormula);
                                }
                              }
                            }
                            
                            /////Logic to increase level if applicable
                            DatabaseService().updateUserStats(workoutCounter, caloriesCounter, hoursCounter, pointsCounter);
                            if(pointsCounter > _profile.levelTo){
                              LevelTracker().updateLevel(_profile.levelTo);
                              /////Go to Level Up recognition
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => ReconitionLevelUp(
                                  organization: _profile.organization,
                                  level: _profile.level, 
                                  headline: '¡Subí al ' + _profile.level + '!',
                                  points: pointsCounter,
                                  time: pointsCounter.toString() + ' PTS',
                              )));
                            } else {
                              /////Go to congrats Page, then home
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => ReconitionWorkout(
                                  organization: _profile.organization,
                                  headline: (trainingSession == '' || trainingSession == null) ? 'Completé un entrenamiento: ' + trainingType : 'Completé un entrenamiento: ' + trainingType + ' - ' + trainingSession,
                                  time: widget.workoutMinutes,
                                  calories: caloriesFormula,
                                  points: 25,
                                )), (Route<dynamic> route) => false);
                            }
                            
                            
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
}
