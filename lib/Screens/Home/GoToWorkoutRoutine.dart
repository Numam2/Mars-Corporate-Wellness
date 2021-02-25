import 'package:flutter/material.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Models/workout.dart';
import 'package:personal_trainer/Screens/Workouts/DownloadWorkout.dart';
import 'package:personal_trainer/Shared/RecognitionGoal.dart';
import 'package:personal_trainer/Shared/RecognitionHabitChallenge.dart';
import 'package:personal_trainer/Shared/RecognitionLevelUp.dart';
import 'package:personal_trainer/Shared/RecognitionWorkout.dart';
import 'package:provider/provider.dart';

class GoToWorkoutRoutine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final _user = Provider.of<UserProfile>(context);

    if (_user == null) {
      return Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: <BoxShadow>[
              new BoxShadow(
                color: Colors.grey,
                offset: new Offset(0.0, 3.0),
                blurRadius: 5.0,
              )
            ]),
      );
    } else if (_user.trainingRoutine == null || _user.trainingRoutine == '') {
      return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
      child: GestureDetector(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: <BoxShadow>[
                  new BoxShadow(
                    color: Colors.grey[350],
                    offset: new Offset(0.0, 3.0),
                    blurRadius: 5.0,
                  )
                ]),
            child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ///Text
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width *0.6,
                              ),
                              child: Text("Mi rutina",
                                style: Theme.of(context).textTheme.title,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Text(
                                "No has empezado ninguna rutina",
                                style: Theme.of(context).textTheme.display2,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width *0.5,
                              ),
                              child: Text(
                                'Explora las rutinas recomendadas',
                                style: Theme.of(context).textTheme.display1,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ]),
                      Spacer(),

                      /// Illustration
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                              width: MediaQuery.of(context).size.width *0.25,
                              child: Image(
                                  image: AssetImage('Images/App Pics/iconos ilust-10.png'),
                                  fit: BoxFit.fitHeight)),
                        ],
                      )
                    ])),
          ),
        ),
      ),
    );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
      child: GestureDetector(
        onTap: () {
          //Go to Download Workout Page
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StreamProvider<List<Workout>>.value(
                    value: DatabaseService().dayWorkout(
                      'Free Routines',
                      _user.trainingRoutine,
                      _user.currentTrainingWeek,
                      _user.currentTrainingDay,                      
                     ),
                    child: DownloadWorkout(
                          collection: 'Free Routines',
                          weekNo: _user.currentTrainingWeek,
                          day: _user.currentTrainingDay,
                          id: _user.trainingRoutine,
                          uid: _user.uid,
                        ),
                  )));
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: <BoxShadow>[
                  new BoxShadow(
                    color: Colors.grey[350],
                    offset: new Offset(0.0, 3.0),
                    blurRadius: 5.0,
                  )
                ]),
            child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ///Text
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width *0.6,
                              ),
                              child: Text(
                                _user.trainingRoutine,
                                style: Theme.of(context).textTheme.title,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Text(
                                "PRÓXIMO",
                                style: Theme.of(context).textTheme.display2,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width *0.6,
                              ),
                              child: Text(
                                _user.currentTrainingWeek +
                                    " - " +
                                    _user.currentTrainingDay,
                                style: Theme.of(context).textTheme.display1,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              _user.currentTrainingDuration,
                              style: Theme.of(context).textTheme.display2,
                            ),
                          ]),
                      Spacer(),

                      /// Illustration
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                              width: MediaQuery.of(context).size.width *0.25,
                              child: Image(
                                  image: AssetImage('Images/App Pics/iconos ilust-10.png'),
                                  fit: BoxFit.fitHeight)),
                        ],
                      )
                    ])),
          ),
        ),
      ),
    );
  }
}
