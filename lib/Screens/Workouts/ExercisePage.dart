import 'package:flutter/material.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/exerciseDetail.dart';
import 'package:personal_trainer/Screens/Workouts/ExerciseDetail.dart';
import 'package:provider/provider.dart';

class ExercisePage extends StatelessWidget {

  final String exerciseName;
  ExercisePage ({Key key, this.exerciseName}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return 
      StreamProvider<ExerciseDetail>.value(
        value: DatabaseService().exerciseDetail(exerciseName),
        child: Scaffold(                  

          ///////////////// App bar /////////////////
          appBar: AppBar(
            backgroundColor: Colors.white,

            // Icon Navigator from Pop window to Home
            leading: InkWell(
              onTap:() {Navigator.pop(context);},
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,),
              ),
              title: Text(exerciseName,
                style: Theme.of(context).textTheme.headline),
              centerTitle: true,
            ),
  
                  ///////////////// Body /////////////////
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ExerciseDetailPage(exerciseName:exerciseName)
          ),

        ),
      );
    }
}