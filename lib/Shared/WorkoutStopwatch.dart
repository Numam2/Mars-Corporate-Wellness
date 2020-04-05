import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Shared/FinishWorkout.dart';
import 'package:simple_animations/simple_animations.dart';

class StopwatchButton extends StatefulWidget {
  @override
  _StopwatchButtonState createState() => _StopwatchButtonState();
}

class _StopwatchButtonState extends State<StopwatchButton> {
  String _stopwatchText = "";
  String _buttonText = "Start";
  Color _buttonColor = Colors.green;
  int minutesElapsed;
  final _stopWatch = new Stopwatch();
  final _timeout = const Duration(seconds: 1);

  bool _startedLoading = false;

  void _startTimeout() {
    new Timer(_timeout, _handleTimeout);
  }

  void _handleTimeout() {
    if (_stopWatch.isRunning) {
      _startTimeout();
    }
    setState(() {
      //4
      _setWorkoutStopwatchText();
    });
  }

  void _startStopButtonPressed() {
    setState(() {
      if (_stopWatch.isRunning) {
        _buttonText = "Start";
        _buttonColor = Colors.green;
        _stopWatch.stop();
        print(_stopwatchText); /////// Get Time when I press Stop Button
        _startedLoading = false;

        showDialog(
            context: context,
            builder: (context) {
              print(_stopWatch.elapsed.inMinutes);
              minutesElapsed = _stopWatch.elapsed.inMinutes;
              return FinishWorkout(workoutMinutes: minutesElapsed);
            });
      } else {
        _buttonText = "Stop";
        _buttonColor = Colors.redAccent[700];
        _stopWatch.start();
        _startTimeout();
        _startedLoading = true;
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
                            style: GoogleFonts.montserrat(color: Colors.white),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          onPressed: _startStopButtonPressed
                        ),
                      );
                    }
                  ),

                  SizedBox(width:40),
                
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: 
                  Text(
                    _stopwatchText,
                    style: GoogleFonts.montserrat(color: Colors.black, fontSize: 16),
                  ),
                // ),
              ]
          ),
      ),
    );
  }
}
