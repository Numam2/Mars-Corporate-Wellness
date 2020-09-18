import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Screens/Workouts/DailyWorkout.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class DownloadWorkout extends StatefulWidget {

  final String collection;
  final String day;
  final String weekNo;
  final String id;
  DownloadWorkout({this.collection, this.day, this.weekNo, this.id});

  @override
  _DownloadWorkoutState createState() => _DownloadWorkoutState();
}

class _DownloadWorkoutState extends State<DownloadWorkout> {

  List<String> exerciseVideoList = [];
  List exerciseList = [];
  bool loading = true;

  Future getExerciseList() async {
    var firestore = Firestore.instance;
    DocumentSnapshot dn = await firestore
        .collection(widget.collection)
        .document(widget.id)
        .collection(widget.weekNo)
        .document(widget.day)
        .get();
    return dn;
  }

  Future getExerciseVideo(exercise) async {
    var firestore = Firestore.instance;
    DocumentSnapshot dn = await firestore
        .collection('Exercise List')
        .document(exercise)
        .get();
    return dn;
  }


  ///////////////////

  Future getVideos() async {

    await getExerciseList().then((result){
      exerciseList = List.from(result.data["Exercises"]);
    });      

  }

  Future getVideoList() async {

    for(int i = 0; i < exerciseList.length; i++){          
      await getExerciseVideo(exerciseList[i]).then((snap){
        exerciseVideoList.add(snap.data['Video'].toString()); 
      });
    }

  }

  @override
  void initState() {

    getVideos().whenComplete((){
        getVideoList().whenComplete((){
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                  DailyWorkout(
                    collection: widget.collection,
                    id: widget.id,
                    weekNo: widget.weekNo,
                    day: widget.day,
                    
                    exerciseList:exerciseList,
                    exerciseVideoList:exerciseVideoList,
                  )
                ));
        });
    });

    super.initState();
  }

  /// UI Widget 
  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Scaffold(

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget>[
            Text('Descargando',
              style: GoogleFonts.montserrat(
                color: Colors.black, fontSize: 14,
              )
            ),
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:20.0),
              child: StepProgressIndicator(
                totalSteps: 100,
                currentStep: 0,
                selectedColor: Theme.of(context).accentColor,
                selectedSize: 4,
                unselectedSize: 4,
                unselectedColor: Theme.of(context).disabledColor.withOpacity(0.2),
                padding: 0,
              ),
            ),
          ]
        )
      ),
    );
  }
}
