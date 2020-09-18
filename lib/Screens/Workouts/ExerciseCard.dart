import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Models/exerciseDetail.dart';
import 'package:personal_trainer/Screens/Workouts/ExerciseVideoSingle.dart';
import 'package:personal_trainer/Screens/Workouts/Exercise_Feedback.dart';
import 'package:provider/provider.dart';

class ExerciseCard extends StatelessWidget {

  final String exerciseName;
  final String exerciseReps;
  final String exerciseWeight;
  final int exerciseDuration;
  final String exerciseSide;

  ExerciseCard({this.exerciseName, this.exerciseReps, this.exerciseWeight, this.exerciseDuration, this.exerciseSide});

  @override
  Widget build(BuildContext context) {

    final exercise = Provider.of<ExerciseDetail>(context);
    
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>                 
                ExerciseVideoSingle(
                  exerciseName: exerciseName,
                  exerciseReps: exerciseReps,
                  exerciseWeight: exerciseWeight,
                  exerciseDuration: exerciseDuration,
                  exerciseVideo: exercise.video,
                  exerciseSide: exerciseSide,
                  exercise: exercise,
                )));
        },
        onLongPress: () {
          showDialog(
              context: context,
              builder: (context) {
                String exercise = exerciseName;
                print(exercise);
                return ExerciseFeedback(exercise: exercise);
              });
        },
        child: Container(
          height: 70,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: <BoxShadow>[
                new BoxShadow(
                  color: Colors.black12,
                  offset: new Offset(0.0, 1.0),
                  blurRadius: 3.0,
                )
              ]),
          child: Padding(
            padding: EdgeInsets.fromLTRB(25.0, 10.0, 40.0, 10.0),
            child: Row(
              children: <Widget>[
                (exerciseWeight == "" || exerciseWeight == null)
                ? Text(
                  (exerciseSide == null || exerciseSide == '')
                  ? exerciseName
                  : exerciseName + " - $exerciseSide",
                    style: GoogleFonts.montserrat(
                      fontSize: 12.0, color: Colors.black,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        (exerciseSide == null || exerciseSide == '')
                        ? exerciseName
                        : exerciseName + " - $exerciseSide",
                        style: GoogleFonts.montserrat(
                          fontSize: 12.0,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          exerciseWeight,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.montserrat(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w200,
                            color: Theme.of(context).canvasColor,
                          ),
                        ),
                      ),
                    ]),
                Spacer(),
                Text(
                  (exerciseDuration == null || exerciseDuration == 0)
                  ? exerciseReps
                  : "$exerciseDuration s",
                  style: GoogleFonts.montserrat(
                    fontSize: 12.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
