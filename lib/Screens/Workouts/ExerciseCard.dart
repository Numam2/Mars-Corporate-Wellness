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
    
    //If image is loading, show grey box
    if(exercise == null){
      return Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
            ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 0.0),
            child: Row(
              children: <Widget>[
                //Image
                Container(
                  height: MediaQuery.of(context).size.width * 0.18,
                  width: MediaQuery.of(context).size.width * 0.18,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.0),     
                    ),
                ),
                SizedBox(width: 10),
                //Text / Text and Weight
                (exerciseWeight == "" || exerciseWeight == null)
                ? Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.5,
                  ),
                  child: Text(
                    (exerciseSide == null || exerciseSide == '')
                    ? exerciseName
                    : exerciseName + " - $exerciseSide",
                      style: GoogleFonts.montserrat(
                        fontSize: 12.0, color: Colors.black,
                      ),
                    ),
                )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.5,
                        ),
                        child: Text(
                          (exerciseSide == null || exerciseSide == '')
                          ? exerciseName
                          : exerciseName + " - $exerciseSide",
                          style: GoogleFonts.montserrat(
                            fontSize: 12.0,
                            color: Colors.black,
                          ),
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
      );
    }
    
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
                return ExerciseFeedback(exercise: exercise);
              });
        },
        child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
            ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 0.0),
            child: Row(
              children: <Widget>[
                //Image
                Container(
                  height: MediaQuery.of(context).size.width * 0.18,
                  width: MediaQuery.of(context).size.width * 0.18,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey[200],               
                    ),
                    child: Image.network(
                      exercise.image,
                      fit: BoxFit.cover
                    )
                ),
                SizedBox(width: 10),
                //Text / Text and Weight
                (exerciseWeight == "" || exerciseWeight == null)
                ? Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.5,
                  ),
                  child: Text(
                    (exerciseSide == null || exerciseSide == '')
                    ? exerciseName
                    : exerciseName + " - $exerciseSide",
                      style: GoogleFonts.montserrat(
                        fontSize: 12.0, color: Colors.black,
                      ),
                    ),
                )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.5,
                        ),
                        child: Text(
                          (exerciseSide == null || exerciseSide == '')
                          ? exerciseName
                          : exerciseName + " - $exerciseSide",
                          style: GoogleFonts.montserrat(
                            fontSize: 12.0,
                            color: Colors.black,
                          ),
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
