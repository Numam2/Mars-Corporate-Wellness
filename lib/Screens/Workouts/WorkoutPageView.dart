import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/exerciseDetail.dart';
import 'package:personal_trainer/Models/workout.dart';
import 'package:personal_trainer/Screens/Workouts/ExerciseCard.dart';
import 'package:personal_trainer/Screens/Workouts/ExerciseVideo.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class WorkoutPageView extends StatefulWidget {
  final List<Workout> workout;
  final List exerciseVideoList;
  final String day;
  final PageController pageController;
  WorkoutPageView({this.workout, this.exerciseVideoList, this.day, this.pageController});

  @override
  _WorkoutPageViewState createState() => _WorkoutPageViewState();
}

class _WorkoutPageViewState extends State<WorkoutPageView> {

  bool loading = true;

  //final pageController = PageController(initialPage: 0);
  int totalPages;
  int currentpage = 0;

  List<Exercise> exerciseList = [];

  File fetchedFile;
  File videoFile;
  int filesDownloaded = 0;

  downloadMedia () async {

     setState(() {
      loading = true;
    });

    for (int i=0; i<widget.exerciseVideoList.length; i++){
      fetchedFile = await DefaultCacheManager().getSingleFile(widget.exerciseVideoList[i]);
      setState((){
        videoFile = fetchedFile;
        filesDownloaded = filesDownloaded + 1;
        print ('File fetched: ${fetchedFile.path}');
      });
    }

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {   

    ///Create List of Pages based on total number of exercises * set
    for (int i=0; i<widget.workout.length; i++) {
      for (int n=0; n < widget.workout[i].rounds; n++){
        widget.workout[i].sets.forEach(
          (x) => exerciseList.add(x));
      }
    }
    totalPages = exerciseList.length + 2;

    ///Download all videos from Storage to view instantly
    downloadMedia().whenComplete(() {
      setState(() {});
      print("success");
    }).catchError((error, stackTrace) {
      print("outer: $error");
    });    

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final List<Workout> workout = widget.workout;

    if(loading){
      return Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget>[
            Text('Descargando',
              style: GoogleFonts.montserrat(
                color: Colors.black, fontSize: 14,
              )
            ),
            SizedBox(height: 15),
            Text(((filesDownloaded/widget.exerciseVideoList.length)*100).round().toString() + '%',
              style: GoogleFonts.montserrat(
                color: Colors.black, fontSize: 14,
              )
            ),
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:20.0),
              child: StepProgressIndicator(
                totalSteps: widget.exerciseVideoList.length,
                currentStep: filesDownloaded,
                selectedColor: Theme.of(context).accentColor,
                selectedSize: 4,
                unselectedSize: 4,
                unselectedColor: Theme.of(context).disabledColor.withOpacity(0.2),
                padding: 0,
              ),
            ),
          ]
        )
      );
    } 

    return PageView(
      physics: BouncingScrollPhysics(),
      controller: widget.pageController,
      onPageChanged: (int page) {
        currentpage = page;
          setState(() {});
        },
      children: <Widget>[
        for (int i=0; i<totalPages; i++)
        (i == 0)
          ? Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: InkWell(
              onTap: () async {
                Navigator.of(context).pop();
                await DefaultCacheManager().emptyCache();
              },
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            centerTitle: true,
            title: Text(widget.day,
                style: Theme.of(context).textTheme.headline),
          ),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:<Widget> [
                ///Sets
                Flexible(
                  fit: FlexFit.loose,
                  child: Container(
                    child: ListView.builder(
                      itemCount: widget.workout.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index){

                        return Padding(
                          padding: EdgeInsets.fromLTRB(15.0, 15, 15.0, 8.0),
                          child: 
                            
                            Column(                
                              children:<Widget>[

                                ///// Display title of set
                                Padding(
                                padding: const EdgeInsets.fromLTRB(15.0, 8.0, 40.0, 8.0),
                                child: 
                                  Row(
                                    children: <Widget>[
                                      Text(workout[index].stage,
                                        style: Theme.of(context).textTheme.title
                                      ),
                                      Spacer(),
                                      Text('x' + workout[index].rounds.toString(),
                                        style: GoogleFonts.montserrat(
                                          fontSize: 16.0, color: Colors.black54),
                                      ),
                                    ],
                                  ),
                              ),

                              ///// Nest inside the list of each exercise within sets
                              ListView.builder(
                                itemCount: workout[index].sets.length,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemBuilder: (context, i){

                                  if(workout[index].sets[i].exerciseName == "Rest" || workout[index].sets[i].exerciseName == "Descansa"){
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Container(
                                        height: 50,
                                        color: Colors.white,
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(25.0, 10.0, 40.0, 10.0),
                                          child: Row(
                                            children: <Widget>[
                                              Text('Descansa',
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 12.0, color: Theme.of(context).canvasColor,
                                                  ),
                                              ),
                                              Spacer(),
                                              Text(
                                                "${workout[index].sets[i].duration} s",
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 12.0,
                                                  color: Theme.of(context).canvasColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                     return StreamProvider<ExerciseDetail>.value(
                                      value: DatabaseService().exerciseDetail(workout[index].sets[i].exerciseName),
                                      child: ExerciseCard(
                                        exerciseName: workout[index].sets[i].exerciseName,
                                        exerciseWeight: workout[index].sets[i].weight,
                                        exerciseReps: workout[index].sets[i].reps,
                                        exerciseDuration: workout[index].sets[i].duration,
                                        exerciseSide: workout[index].sets[i].side,
                                      ),
                                    );
                                  }


                                }
                              )

                            ] 
                          ), 
                              
                        );
                      }
                    )
                  ),
                ),
              ]
            ),
            )

          : (i == totalPages - 1) 
            ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
                Text(
                  "¡LISTO!",
                  style: GoogleFonts.montserrat(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Presiona el botón para finalizar",
                  style: GoogleFonts.montserrat(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
              ] 
            )
            : StreamProvider<ExerciseDetail>.value(
              value: DatabaseService().exerciseDetail(exerciseList[i-1].exerciseName),
              child: ExerciseVideo(
                exerciseName: exerciseList[i-1].exerciseName,
                exerciseReps: exerciseList[i-1].reps,
                exerciseWeight: exerciseList[i-1].weight,
                exerciseSide: exerciseList[i-1].side,
                exerciseDuration: exerciseList[i-1].duration,
                pageController: widget.pageController,
                totalExercises: totalPages,
                ),
              ),
                    
      ]
    );
  }
}
