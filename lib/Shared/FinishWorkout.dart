import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_trainer/Screens/Home/Inicio_Navigate.dart';

class FinishWorkout extends StatefulWidget {
  final int workoutMinutes;
  FinishWorkout({Key key, this.workoutMinutes}) : super(key: key);

  @override
  _FinishWorkoutState createState() => _FinishWorkoutState();
}

class _FinishWorkoutState extends State<FinishWorkout> {
  var firestore = Firestore.instance;
  int workoutCounter;
  int hoursCounter;
  int caloriesFormula;
  int met = 7;
  int caloriesCounter;

  ////////Total calories burned = Duration (in minutes)*(MET*3.5*weight in kg)/200
  ///MET (Metabolic Equivalent for Task) - USING 7 AS AVG  => https://sites.google.com/site/compendiumofphysicalactivities/Activity-Categories/conditioning-exercise
  ///Reference for formula https://www.verywellfit.com/how-many-calories-you-burn-during-exercise-4111064

  //////// Create a future that retrieves Firestore data for Weeks collection
  Future getUserProfile() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    DocumentSnapshot docRef =
        await firestore.collection("User Profile").document(uid).get();
    return docRef.data;
  }

  Future updateUserData(int workout, int caloriesBurnt, int hours) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return await firestore.collection('User Profile').document(uid).updateData({
      'Accumulated Workouts': workout,
      'Calories Burnt': caloriesBurnt,
      'Accumulated Hours': hours,
    });
  }

  void _dontendWorkout() async {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserProfile(),
        builder: (context, snapshot) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
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
                        "Did you complete the workout?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.bold,
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
                              height: 35,
                              width: 100,
                              child: RaisedButton(
                                onPressed: () async {
                                  workoutCounter =
                                      snapshot.data["Accumulated Workouts"] + 1;
                                  caloriesFormula = (widget.workoutMinutes*(met*3.5*int.parse(snapshot.data["Weight"]))/200).round();
                                  caloriesCounter = 
                                      snapshot.data["Calories Burnt"] + caloriesFormula;
                                  hoursCounter = 
                                      (snapshot.data["Accumulated Hours"] + (widget.workoutMinutes/60)).round();
                                  print(caloriesCounter);
                                  await updateUserData(workoutCounter, caloriesCounter, hoursCounter);                                  
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => InicioNew()));
                                },
                                color: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    "Yes",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                ),
                              )),
                          SizedBox(width: 20),
                          Container(
                              height: 35,
                              width: 100,
                              child: RaisedButton(
                                onPressed: _dontendWorkout,
                                color: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    "No",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
