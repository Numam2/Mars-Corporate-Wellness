import 'package:flutter/material.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/weeks.dart';
import 'package:personal_trainer/Models/workout.dart';
import 'package:personal_trainer/Screens/Workouts/WorkoutPage.dart';
import 'package:personal_trainer/Shared/WorkoutStopwatch.dart';
import 'package:provider/provider.dart';

class DailyWorkout extends StatefulWidget {

  final String collection;
  final String day;
  final String weekNo;
  final String id;

  final List<String> exerciseVideoList;
  final List exerciseList;

  DailyWorkout({this.collection, this.day, this.weekNo, this.id , this.exerciseVideoList, this.exerciseList});

  @override
  _DailyWorkoutState createState() => _DailyWorkoutState();
}

class _DailyWorkoutState extends State<DailyWorkout> {

  final pageController = PageController(initialPage: 0);

  /// UI Widget 
  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers:[
        StreamProvider<List<Workout>>.value(value: DatabaseService().dayWorkout(widget.collection, widget.id, widget.weekNo, widget.day)),
        StreamProvider<WeekDays>.value(value: DatabaseService().trainingDayDetails(widget.collection, widget.id, widget.weekNo, widget.day)),
      ],
      child: SafeArea(
        child: Scaffold(

          body: Stack(
            children: <Widget>[
                    ///// Parent List view showing number of sets with their titles
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom:70.0),
                    //   child: WorkoutSets(),
                    // ),

              Padding(
                padding: const EdgeInsets.only(bottom:75.0),
                child: WorkoutPage(day:widget.day, exerciseVideoList: widget.exerciseVideoList, pageController: pageController),
              ),

              StopwatchButton(
                trainingRoutine: widget.id, 
                currentDay: widget.day ?? '', 
                currentWeek: widget.weekNo ?? '', 
                pageController: pageController
              ),
            ],
          ),
        ),
      ),
    );
  }
}
