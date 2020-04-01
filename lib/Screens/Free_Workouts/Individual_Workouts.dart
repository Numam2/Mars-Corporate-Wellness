import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_trainer/Screens/Workouts/Exercise_Detail.dart';
import 'package:personal_trainer/Screens/Workouts/Exercise_Feedback.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:personal_trainer/Shared/WorkoutStopwatch.dart';

class IndividualWorkoutView extends StatefulWidget {

  final String individualWorkout;
  IndividualWorkoutView({Key key, this.individualWorkout}) : super(key: key);

  @override
  _IndividualWorkoutViewState createState() => _IndividualWorkoutViewState();
}

class _IndividualWorkoutViewState extends State<IndividualWorkoutView> {

  Future getSets() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection("Individual Workouts")
        .document(widget.individualWorkout)
        .collection("Workout")
        .getDocuments();
    return qn.documents;
  }

  Future _getSets;

@override
void initState() {
  _getSets = getSets(); // only create the future once.
  super.initState();
}

  void _goBack() async {
    Navigator.of(context).pop();
  }

  /// Widget Itself
  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: _getSets,
      builder: (context, snapshot) {

         ////handle wait time for the Future with connection state
          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(
            child:Loading()
          );

          ///Perform if there is data to show
          } else {

            return 
              Scaffold(
                    ///// App bar design
                    appBar: AppBar(
                      backgroundColor: Colors.black,
                      leading: InkWell(
                        onTap: _goBack,
                        child: Icon(
                          Icons.keyboard_arrow_left
                        ),
                      ),
                      centerTitle: true,
                      title: Text(widget.individualWorkout),
                        // actions: <Widget>[
                        //   Padding(
                        //     padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20.0),
                        //     child: Text(_stopwatchText,                              
                        //       style: TextStyle(fontSize: 16.0),
                        //     ),
                        //   ),
                        // ],
                    ),
                  
                  body:

                  Stack(
                    children: <Widget>[

                    ///// Parent List view showing number of sets with their titles
                    Container(
                      padding: EdgeInsets.only(bottom:70),
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context,index){
                            
                            print(snapshot.data);
                            //// Create Objects defining the list of exercises and the Map of properties of each exercise
                            List<dynamic> exercises = snapshot.data[index].data["Workout"] as List;
                            
                              return                             
                                Padding(
                                  padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 8.0),
                                  child: Column(
                                    children: <Widget>[

                                      ///// Display title of set
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(15.0, 8.0, 60.0, 8.0),
                                        child: 
                                        Row(
                                          children: <Widget>[
                                            Text(snapshot.data[index].data["Stage"],
                                              style: TextStyle(
                                                fontSize: 23.0, fontFamily: "Roboto", fontWeight: FontWeight.bold),
                                            ),
                                            Spacer(),
                                              Text(snapshot.data[index].data["Rounds"],
                                              style: TextStyle(
                                              fontSize: 16.0, fontFamily: "Roboto", color: Colors.black54),
                                              ),
                                          ],
                                        ),
                                      ),

                                      ///// Nest inside the list of each exercise within sets
                                      ListView.builder(
                                        itemCount: exercises.length,
                                        shrinkWrap: true,
                                        physics: ClampingScrollPhysics(),
                                        itemBuilder: (context, index){

                                          ////// If the exercise contains weight
                                          if (exercises.elementAt(index)["Weight"] == ""){

                                            return Padding(
                                              padding: const EdgeInsets.only(top: 5.0),
                                              child:
                                                                        
                                              //////// Card design for each exercise
                                              InkWell(
                                                onTap: (){
                                                  String exercise = exercises.elementAt(index)["Description"].toString();
                                                  print(exercise);
                                                  Navigator.push(context, 
                                                    MaterialPageRoute(builder: (context) => ExerciseDetail(exercise: exercise)));
                                                },
                                                onLongPress: (){
                                                  showDialog(                                                  
                                                    context: context,
                                                    builder: (context){
                                                      String exercise = exercises.elementAt(index)["Description"].toString();
                                                      print(exercise);
                                                        return ExerciseFeedback(exercise:exercise);
                                                    }
                                                  );                        
                                                },  
                                                child: Container( 
                                                  height: 70,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(8.0),
                                                    boxShadow: <BoxShadow> [
                                                      new BoxShadow(
                                                        color: Colors.black12,
                                                        offset: new Offset(0.0, 1.0),
                                                        blurRadius: 3.0,
                                                      )
                                                    ]
                                                  ),
                                                  child:
                                                      Padding(
                                                        padding: EdgeInsets.fromLTRB(25.0, 10.0, 40.0, 10.0),
                                                          child: 
                                                          
                                                                  Row(children: <Widget>[
                                                                    Text(exercises.elementAt(index)["Description"],
                                                                      style: TextStyle(
                                                                        fontSize: 14.0, fontFamily: "Roboto", color: Colors.black
                                                                        ),
                                                                      ),
                                                                    Spacer(),
                                                                      Text("x" + exercises.elementAt(index)["Reps"],
                                                                      style: TextStyle(
                                                                          fontSize: 14.0, fontFamily: "Roboto", color: Colors.black,
                                                                          ),
                                                                      ),
                                                                    ],
                                                                  ),

                                                      ),
                                                    
                                                  ),
                                                ),
                                              );

                                          ////// If the exercise contains weight
                                          } else {

                                            return Padding(
                                              padding: const EdgeInsets.only(top: 5.0),
                                              child:
                                                                        
                                              //////// Card design for each exercise
                                              InkWell(
                                                onTap: (){
                                                  String exercise = exercises.elementAt(index)["Description"].toString();
                                                  print(exercise);
                                                  Navigator.push(context, 
                                                    MaterialPageRoute(builder: (context) => ExerciseDetail(exercise: exercise)));
                                                },
                                                onLongPress: (){
                                                  showDialog(                                                  
                                                    context: context,
                                                    builder: (context){
                                                      String exercise = exercises.elementAt(index)["Description"].toString();
                                                      print(exercise);
                                                        return ExerciseFeedback(exercise:exercise);
                                                    }
                                                  );   
                                                },                                        
                                                child: Container( 
                                                  height: 70,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(8.0),
                                                    boxShadow: <BoxShadow> [
                                                      new BoxShadow(
                                                        color: Colors.black12,
                                                        offset: new Offset(0.0, 1.0),
                                                        blurRadius: 3.0,
                                                      )
                                                    ]
                                                  ),                                         
                                                  child:
                                                      Padding(
                                                        padding: EdgeInsets.fromLTRB(25.0, 10.0, 40.0, 10.0),
                                                          child: Row(
                                                            children: <Widget>[

                                                              /////Column with Description and Weight
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 5.0),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,                                                                                                                       
                                                                  children: <Widget>[

                                                                    Text(exercises.elementAt(index)["Description"],
                                                                      textAlign: TextAlign.left,
                                                                      style: TextStyle(
                                                                          fontSize: 14.0, fontFamily: "Roboto", color: Colors.black,
                                                                          ),
                                                                        ),

                                                                    Padding(
                                                                      padding: const EdgeInsets.only(top: 5.0),
                                                                      child: Text(exercises.elementAt(index)["Weight"],
                                                                        textAlign: TextAlign.left,
                                                                        style: TextStyle(
                                                                            fontSize: 12.0, fontFamily: "Roboto", color: Colors.black54,
                                                                            ),
                                                                          ),
                                                                    ),

                                                                  ],
                                                                ),
                                                              ),

                                                              /////Space to put Reps at Right
                                                              Spacer(),

                                                              /////Reps on the other side
                                                              Text("x" + exercises.elementAt(index)["Reps"],
                                                                style: TextStyle(
                                                                    fontSize: 14.0, fontFamily: "Roboto", color: Colors.black,
                                                                      ),
                                                                ),
                                                              

                                                            ],
                                                          )
                                                      ),
                                                    
                                                  ),
                                                ),
                                              );

                                          } /////// End else 


                                        }
                                      ),
                                      
                                    ],
                                  ),
                                );
                          }
                        ),
                    ),

                      StopwatchButton()

                    ],
                  ),

                );

            
          }
      },
    );
  }
}
