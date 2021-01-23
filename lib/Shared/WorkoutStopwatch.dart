import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Models/weeks.dart';
import 'package:personal_trainer/Shared/FinishWorkout.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';

class StopwatchButton extends StatefulWidget {

  final String nextTrainingDay;
  final String nextTrainingWeek;
  final String trainingRoutine;
  final String currentWeek;
  final String currentDay;
  final PageController pageController;
  StopwatchButton({this.nextTrainingDay, this.nextTrainingWeek, this.trainingRoutine, this.currentWeek, this.currentDay, this.pageController});

  @override
  _StopwatchButtonState createState() => _StopwatchButtonState();
}

class _StopwatchButtonState extends State<StopwatchButton> {
  String _stopwatchText = "00:00:00";
  String _buttonText = "EMPEZAR";
  Color _buttonColor = Color(0xff00CE7C);
  int minutesElapsed;
  final _stopWatch = new Stopwatch();
  final _timeout = const Duration(seconds: 1);
  WeekDays _trainingDay;

  bool _startedLoading = false;

  void _startTimeout() {
    new Timer(_timeout, _handleTimeout);
  }

  void _handleTimeout() {
    if (_stopWatch.isRunning) {
      _startTimeout();
    }
    if (mounted){
      setState(() {
        //4
        _setWorkoutStopwatchText();
      });
    }
  }

  void _startStopButtonPressed() {
    setState(() {
      if (_stopWatch.isRunning) {
        _buttonText = "EMPEZAR";
        _buttonColor = Color(0xff00CE7C);
        _stopWatch.stop();
        _startedLoading = false;

        if (widget.trainingRoutine == 'Individual Workouts') {
          showDialog(
            context: context,
            builder: (context) {
              print(_stopWatch.elapsed.inMinutes);
              minutesElapsed = _stopWatch.elapsed.inMinutes;
              return FinishWorkout(
                workoutMinutes: minutesElapsed, 
                trainingRoutine: widget.trainingRoutine,
                currentTrainingDuration: _trainingDay.time ?? '',
                currentDay: widget.currentDay ?? '',
              );
            });
        } else {
          showDialog(
            context: context,
            builder: (context) {
              print(_stopWatch.elapsed.inMinutes);
              minutesElapsed = _stopWatch.elapsed.inMinutes;
              return FinishWorkout(
                workoutMinutes: minutesElapsed, 
                trainingRoutine: (_trainingDay.nextDay == ""  || _trainingDay.nextDay == "Done") ? "" : widget.trainingRoutine,
                nextTrainingWeek: _trainingDay.nextWeek ?? '',
                nextTrainingDay: _trainingDay.nextDay ?? '',
                nextTrainingDuration: _trainingDay.nextTime ?? '',
                currentTrainingDayIndex: _trainingDay.currentDayIndex ?? '', 
                maxTrainingDayIndex: _trainingDay.maxDayIndex ?? '',
                currentTrainingDuration: _trainingDay.time ?? '',
                currentDay: widget.currentDay ?? '',
                currentWeek: widget.currentWeek ?? '',
              );
            });
        }   

      } else {
        _buttonText = "DETENER";
        _buttonColor = Colors.redAccent[700];
        _stopWatch.start();
        _startTimeout();
        _startedLoading = true;
        widget.pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
      }
    });
  }

  void _setWorkoutStopwatchText() {
    _stopwatchText = _stopWatch.elapsed.inHours.toString().padLeft(2, "0") +
        ":" +
        (_stopWatch.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
        ":" +
        (_stopWatch.elapsed.inSeconds % 60).toString().padLeft(2, "0");
  }


  @override
  Widget build(BuildContext context) {

    _trainingDay = Provider.of<WeekDays>(context);

    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 20, bottom: 30.0, right: 20),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.start, 
            children: <Widget>[
            ControlledAnimation(
                duration: Duration(milliseconds: 300),
                tween: Tween(begin: 175.0, end: 100.0),
                playback:
                    !_startedLoading ? Playback.PAUSE : Playback.PLAY_FORWARD,
                builder: (context, width) {
                  return 
                    Container(
                      width: width,
                      height: 40,
                      child: RaisedButton(
                          color: _buttonColor,
                          autofocus: false,
                          clipBehavior: Clip.hardEdge,
                          elevation: 10,
                          child: Text(
                            _buttonText,
                            style: Theme.of(context).textTheme.button,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          onPressed:_startStopButtonPressed
                        ),
                      );
                    
                    }
                  ),
              
              Spacer(),

                  //SizedBox(width:40),
                
              Text(
                  _stopwatchText,
                  style: GoogleFonts.montserrat(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
                ),

              ]
          ),
      ),
    );
  }  
}
