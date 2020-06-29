import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Models/exerciseDetail.dart';
import 'package:personal_trainer/Screens/Workouts/VideoContainer.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ExerciseVideoSingle extends StatefulWidget {
  final String exerciseName;
  final String exerciseReps;
  final String exerciseWeight;
  final int exerciseDuration;
  final String exerciseVideo;
  final ExerciseDetail exercise;
  ExerciseVideoSingle(
      {this.exerciseName,
      this.exerciseReps,
      this.exerciseWeight,
      this.exerciseDuration,
      this.exerciseVideo,
      this.exercise});

  @override
  _ExerciseVideoSingleState createState() => _ExerciseVideoSingleState();
}

class _ExerciseVideoSingleState extends State<ExerciseVideoSingle> {

  String _stopwatchText;  
  Icon buttonIcon = Icon(Icons.play_arrow, color: Colors.black, size: 20);
  int minutesElapsed;
  int countdownMinutesElapsed;
  final _stopWatch = new Stopwatch();
  final _timeout = const Duration(seconds: 1);  

  void _startTimeout() {
    new Timer(_timeout, _handleTimeout);
  }

  void _handleTimeout() {
    if (_stopWatch.isRunning) {
      _startTimeout();
    }
    if (mounted){
      setState(() {
        _setWorkoutStopwatchText();
      });
    }
    
  }

  void _startStopButtonPressed() {
    setState(() {
      if (_stopWatch.isRunning) {
        // buttonIcon = Icon(Icons.play_arrow, color: Colors.black, size: 20);
        _stopWatch.stop();
      } else {
        // buttonIcon = Icon(Icons.pause, color: Colors.black, size: 20);
        _stopWatch.start();
        _startTimeout();
      }
    });
  }

  void _setWorkoutStopwatchText() async {
    _stopwatchText =
        (widget.exerciseDuration - _stopWatch.elapsed.inSeconds % 60)
            .toString()
            .padLeft(2, "0");
    if (_stopwatchText == '00') {
      setState(() {
        _stopWatch.stop();        
      });
    }
  }
  


  @override
  void initState() {
    try {
      _stopwatchText = widget.exerciseDuration.toString();           
    } catch (e) {
      print(e);
    }

    super.initState();
  }


  @override
  Widget build(BuildContext context) {    

    if(widget.exercise == null){
      return Loading();
    }
    
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
          ///Video
          VideoContainer(exerciseVideoURL: widget.exercise.video, hasPageController: false),
          SizedBox(height: 30),

          ///Exercise and Weight
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(widget.exerciseName,
                      style: Theme.of(context).textTheme.title)),
              Spacer(),
              Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Text(
                      (widget.exerciseWeight != null) ? widget.exerciseWeight : '',
                      style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: Theme.of(context).canvasColor,
                          fontWeight: FontWeight.w500)))
            ],
          ),
          SizedBox(height: 20),

          ///Timer/Reps
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:<Widget>[
                    CircularStepProgressIndicator(
                      totalSteps:
                          (widget.exerciseDuration == null || widget.exerciseDuration == 0)
                              ? 100
                              : widget.exerciseDuration,
                      currentStep:
                          (widget.exerciseDuration == null || widget.exerciseDuration == 0)
                              ? 0
                              : _stopWatch.elapsed.inSeconds,
                      selectedColor: Theme.of(context).accentColor,
                      selectedStepSize: 4,
                      unselectedStepSize: 4,
                      unselectedColor: Theme.of(context).disabledColor.withOpacity(0.2),
                      padding: 0,
                      width: 150,
                      height: 150,
                      child: ClipOval(
                        child: Container(
                            height: 150,
                            width: 150,
                            child: Center(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      (widget.exerciseDuration == null ||
                                              widget.exerciseDuration == 0)
                                          ? widget.exerciseReps
                                          : _stopwatchText,
                                      style: GoogleFonts.montserrat(
                                          fontSize: 34,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      (widget.exerciseDuration == null ||
                                              widget.exerciseDuration == 0)
                                          ? 'REPS'
                                          : 'SEG',
                                      style: GoogleFonts.montserrat(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey),
                                      textAlign: TextAlign.center,
                                    ),
                                  ]),
                            )),
                      ),
                    ),
                    SizedBox(height: 10),

                    ///Start Timer
                    (widget.exerciseDuration == null || widget.exerciseDuration == 0)
                    ? SizedBox()
                    : GestureDetector(
                        onTap:(_stopwatchText == '00') ? (){} : _startStopButtonPressed,
                        child: Container(
                            padding: EdgeInsets.all(8.0),
                            decoration:
                                BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                            child: _stopWatch.isRunning
                            ? Icon(Icons.pause, color: Colors.black, size: 20)
                            : Icon(Icons.play_arrow, color: Colors.black, size: 20)                              
                          ),
                      ),  
                    ] 
                  ),
                ),
              ),
            ),
          SizedBox(height: 75),                
        ]),
      ),
    );
  }
}
