import 'package:flutter/material.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/explore.dart';
import 'package:personal_trainer/Screens/Free_Workouts/FreeRoutinesList.dart';
import 'package:personal_trainer/Screens/Free_Workouts/IndividualWorkoutsList.dart';
import 'package:provider/provider.dart';

class WorkoutsHome extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return StreamProvider<List<ExploreRoutines>>.value(
      value: DatabaseService().freeRoutinesList,
      child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                
                //Free Routines Carousel
                Container(
                  height: 250,
                  child: FreeRoutinesList(),
                ),

                ///Workouts: Entrenamientos de la semana
                // Container(
                //   padding: EdgeInsets.fromLTRB(20.0, 15.0, 10.0, 10.0),
                //   width: double.infinity,
                //   //color: Colors.blue,
                //   child: Text("Entrenamientos de la semana",
                //       style: Theme.of(context).textTheme.title),
                // ),
                // SizedBox(height: 10),
                // Container(
                //   height: 160,
                //   child: StreamProvider<List<ExploreWorkouts>>.value(
                //     value: DatabaseService().freeWorkoutsList('15 minute'),
                //     child: IndividualWorkoutsList()),               
                // ),

                ///Workout: 15 min
                Container(
                  padding: EdgeInsets.fromLTRB(20.0, 25.0, 10.0, 10.0),
                  width: double.infinity,
                  //color: Colors.blue,
                  child: Text("15 minutos o menos",
                      style: Theme.of(context).textTheme.title),
                ),
                SizedBox(height: 10),
                Container(
                  height: 160,
                  child: StreamProvider<List<ExploreWorkouts>>.value(
                    value: DatabaseService().freeWorkoutsList('15 minute'),
                    child: IndividualWorkoutsList()),               
                ),

                ///Workout: Stretching
                Container(
                  padding: EdgeInsets.fromLTRB(20.0, 25.0, 10.0, 10.0),
                  width: double.infinity,
                  //color: Colors.blue,
                  child: Text("Stretching",
                      style: Theme.of(context).textTheme.title),
                ),
                SizedBox(height: 10),
                Container(
                  height: 160,
                  child: StreamProvider<List<ExploreWorkouts>>.value(
                    value: DatabaseService().freeWorkoutsList('Stretching'),
                    child: IndividualWorkoutsList()),               
                ),

                ///Workout: Home
                Container(
                  padding: EdgeInsets.fromLTRB(20.0, 25.0, 10.0, 10.0),
                  width: double.infinity,
                  //color: Colors.blue,
                  child: Text("En casa",
                      style: Theme.of(context).textTheme.title),
                ),
                SizedBox(height: 10),
                Container(
                  height: 160,
                  child: StreamProvider<List<ExploreWorkouts>>.value(
                    value: DatabaseService().freeWorkoutsList('Home'),
                    child: IndividualWorkoutsList()),               
                ),


              ],
            ),
          ),
        ),
    );
  }
}
