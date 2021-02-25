import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Models/exerciseDetail.dart';
import 'package:personal_trainer/Screens/Workouts/VideoContainer.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:audioplayers/audio_cache.dart';


class ExerciseVideo extends StatefulWidget {
  final String exerciseName;
  final String exerciseReps;
  final String exerciseWeight;
  final String exerciseSide;
  final int exerciseDuration;
  final String exerciseVideo;
  final PageController pageController;
  final int totalExercises;
  ExerciseVideo(
      {this.exerciseName,
      this.exerciseReps,
      this.exerciseWeight,
      this.exerciseSide,
      this.exerciseDuration,
      this.exerciseVideo,
      this.pageController,
      this.totalExercises});

  @override
  _ExerciseVideoState createState() => _ExerciseVideoState();
}

class _ExerciseVideoState extends State<ExerciseVideo> {
  String _stopwatchText;
  Icon buttonIcon = Icon(Icons.play_arrow, color: Colors.black, size: 20);
  int minutesElapsed;
  int countdownMinutesElapsed;
  final _stopWatch = new Stopwatch();
  final _timeout = const Duration(seconds: 1);
  static AudioCache player = new AudioCache();

  void _startTimeout() {
    new Timer(_timeout, _handleTimeout);
  }

  void _handleTimeout() {
    if (_stopWatch.isRunning) {
      _startTimeout();
    }
    if (mounted) {
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

  void doNothing(){

  }

  void _setWorkoutStopwatchText() async {
    _stopwatchText =
        (widget.exerciseDuration - _stopWatch.elapsed.inSeconds % 60)
            .toString()
            .padLeft(2, "0");
    if (_stopwatchText == '00') {
      setState(() {
        _timer.cancel();
        _stopWatch.stop();
      });
      player.play('End Workout Bell.mp3');   
      await widget.pageController
          .nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  //////// Coundtdown before starting Exercise Timer

  Timer _timer;
  int _start = 10;

  void startTimer() {
    countingdown = true;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start == 3){
            player.play('Start Workout Countdown.mp3');
            _start = _start - 1;
          } else if (_start < 1) {
            timer.cancel();
            countingdown = false;
            _stopWatch.start();
            _startTimeout();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
      setState(() {
        _timer.cancel();
        _stopWatch.stop();
      });      
    super.dispose();
  }

  bool countingdown;

  @override
  void initState() {
    try {
      _stopwatchText = widget.exerciseDuration.toString();

      if(widget.exerciseName == "Rest"){
        _stopWatch.start();
        _startTimeout();
      } else {
        if (widget.exerciseDuration != null && widget.exerciseDuration != 0) {
          startTimer();
        } else {
          countingdown = false;
        }
      }
            
    } catch (e) {
      print(e);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.exerciseName == "Rest" || widget.exerciseName == "Descansa") {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:<Widget>[
          Text("Descansa",
            style: Theme.of(context).textTheme.title
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ///Navigate Before
              GestureDetector(
                onTap: () {
                  setState(() {
                    _stopWatch.stop();
                  });
                  widget.pageController.previousPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease);
                },
                child: Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: Icon(Icons.navigate_before,
                        color: Colors.grey, size: 30)),
              ),
              Spacer(),

              ///Reps/Timer
              CircularStepProgressIndicator(
                totalSteps: (widget.exerciseDuration == null ||
                        widget.exerciseDuration == 0)
                    ? 60
                    : widget.exerciseDuration,
                currentStep: (widget.exerciseDuration == null ||
                        widget.exerciseDuration == 0)
                    ? 0
                    : _stopWatch.elapsed.inSeconds,
                selectedColor: Theme.of(context).accentColor,
                selectedStepSize: 4,
                unselectedStepSize: 4,
                unselectedColor:
                    Theme.of(context).disabledColor.withOpacity(0.2),
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
              Spacer(),

              ///Navigate Next
              GestureDetector(
                onTap: () {
                  setState(() {
                    _stopWatch.stop();
                  });
                  widget.pageController.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease);
                },
                child: Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: Icon(Icons.navigate_next,
                        color: Colors.grey, size: 30)),
              ),
            ]),
          SizedBox(height: 20),
          GestureDetector(
              onTap: _startStopButtonPressed,
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white),
                child: _stopWatch.isRunning
                  ? Icon(Icons.pause,
                    color: Colors.black, size: 20)
                  : Icon(Icons.play_arrow,
                    color: Colors.black, size: 20)),
                ),
        ] 
      );
    }

    var exercise;

    try {
      exercise = Provider.of<ExerciseDetail>(context);
    } catch (e) {
      print(e);
    }

    if (exercise == null) {
      return SizedBox();
    }

    return Stack(children: <Widget>[
      //Countdown timer before starting
      countingdown
          ? Center(
              child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: Center(
                    child: Text("$_start",
                        style: GoogleFonts.montserrat(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        )),
                  )),
            )
          : SizedBox(),
      //Exercise demo
      Opacity(
        opacity: countingdown ? 0.25 : 1,
        child: Column(children: <Widget>[
          ///Video
          VideoContainer(
              exerciseVideoURL: exercise.video,
              pageController: widget.pageController,
              hasPageController: true),

          ///Step counter
          StepProgressIndicator(
            totalSteps: widget.totalExercises,
            currentStep: widget.pageController.page.round(),
            selectedColor: Theme.of(context).accentColor,
            selectedSize: 4,
            unselectedSize: 4,
            padding: 0.5,
            unselectedColor: Theme.of(context).disabledColor.withOpacity(0.2),
          ),
          SizedBox(height: 20),

          ///Exercise and Weight
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: (widget.exerciseSide == null || widget.exerciseSide == "")
                  ? Text(widget.exerciseName,
                      style: Theme.of(context).textTheme.title)
                  : Text(widget.exerciseName + " (" + widget.exerciseSide + ")",
                      style: Theme.of(context).textTheme.title)),
              Spacer(),
              Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Text(
                      (widget.exerciseWeight != null)
                          ? widget.exerciseWeight
                          : '',
                      style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: Theme.of(context).canvasColor,
                          fontWeight: FontWeight.w500)))
            ],
          ),
          //SizedBox(height: 5),

          ///Timer/Reps
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            ///Navigate Before
                            GestureDetector(                              
                              onTap: () async {
                                if (countingdown) {
                                 //Do nothing  
                                } else {
                                  if (widget.exerciseDuration == null ||
                                        widget.exerciseDuration == 0) {

                                      widget.pageController.previousPage(
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.ease);
                                  } else {
                                    setState(() {
                                      _stopWatch.stop();
                                    });
                                    _timer.cancel();
                                    widget.pageController.previousPage(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                  }
                                }
                              },
                              child: Container(
                                  padding: EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  child: Icon(Icons.navigate_before,
                                      color: Colors.grey, size: 30)),
                            ),
                            Spacer(),

                            ///Reps/Timer
                            CircularStepProgressIndicator(
                              totalSteps: (widget.exerciseDuration == null ||
                                      widget.exerciseDuration == 0)
                                  ? 100
                                  : widget.exerciseDuration,
                              currentStep: (widget.exerciseDuration == null ||
                                      widget.exerciseDuration == 0)
                                  ? 0
                                  : _stopWatch.elapsed.inSeconds,
                              selectedColor: Theme.of(context).accentColor,
                              selectedStepSize: 4,
                              unselectedStepSize: 4,
                              unselectedColor: Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.2),
                              padding: 0,
                              width: MediaQuery.of(context).size.height * 0.25,
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: ClipOval(
                                child: Container(
                                    height: MediaQuery.of(context).size.height * 0.25,
                                    width: MediaQuery.of(context).size.height * 0.25,
                                    child: Center(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              (widget.exerciseDuration ==
                                                          null ||
                                                      widget.exerciseDuration ==
                                                          0)
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
                                              (widget.exerciseDuration ==
                                                          null ||
                                                      widget.exerciseDuration ==
                                                          0)
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
                            Spacer(),

                            ///Navigate Next
                            GestureDetector(
                              onTap: () async {
                                if (countingdown){
                                  //Don nothing
                                } else {
                                  if (widget.exerciseDuration == null ||
                                        widget.exerciseDuration == 0) {
                                          
                                      widget.pageController.nextPage(
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.ease);
                                  } else {
                                    setState(() {
                                      _stopWatch.stop();
                                    });
                                    _timer.cancel();
                                    widget.pageController.nextPage(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                  }
                                }
                              },
                              child: Container(
                                  padding: EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  child: Icon(Icons.navigate_next,
                                      color: Colors.grey, size: 30)),
                            ),
                          ]),

                      ///Start Timer
                      (widget.exerciseDuration == null ||
                              widget.exerciseDuration == 0)
                          ? SizedBox()
                          : GestureDetector(
                              onTap: countingdown ? doNothing : _startStopButtonPressed,
                              child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  child: _stopWatch.isRunning
                                      ? Icon(Icons.pause,
                                          color: Colors.black, size: 20)
                                      : Icon(Icons.play_arrow,
                                          color: Colors.black, size: 20)),
                            ),
                    ]),
              ),
            ),
          ),
          //SizedBox(height: MediaQuery.of(context).size.height *0.2),
        ]),
      ),
    ]);
  }
}
