import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Models/workout.dart';
import 'package:personal_trainer/Screens/Home/HirePersonalizedRoutine.dart';
import 'package:personal_trainer/Screens/Workouts/DailyWorkout.dart';
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
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HirePersonalizedRoutine()));
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
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://firebasestorage.googleapis.com/v0/b/ludus-health-coach.appspot.com/o/App%20Images%2FStart%20Personalized%20Routine.jpg?alt=media&token=96e92e4e-62a1-4dd1-ac0b-b9319016efa9'),
                      fit: BoxFit.fitWidth,
                      colorFilter:
                          ColorFilter.mode(Colors.black38, BlendMode.darken)),
                  boxShadow: <BoxShadow>[
                    new BoxShadow(
                      color: Colors.grey,
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
                            Text(
                              'Obtén una',
                              style: GoogleFonts.montserrat(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 5),
                            Text(
                              'rutina personalizada',
                              style: Theme.of(context).textTheme.caption,
                              textAlign: TextAlign.start,
                            ),
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StreamProvider<List<Workout>>.value(
                    value: DatabaseService().dayWorkout(
                      _user.personalizedRoutine
                        ? 'Training Routine'
                        : 'Free Routines',
                      _user.trainingRoutine,
                      _user.currentTrainingWeek,
                      _user.currentTrainingDay,                      
                     ),
                    child: DailyWorkout(
                          collection: _user.personalizedRoutine
                              ? 'Training Routine'
                              : 'Free Routines',
                          weekNo: _user.currentTrainingWeek,
                          day: _user.currentTrainingDay,
                          id: _user.trainingRoutine,
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
                            Text(
                              _user.personalizedRoutine
                                  ? "Mi entrenamiento"
                                  : _user.trainingRoutine,
                              style: Theme.of(context).textTheme.title,
                              textAlign: TextAlign.start,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Text(
                                "PRÓXIMO",
                                style: Theme.of(context).textTheme.display2,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              _user.currentTrainingWeek +
                                  " - " +
                                  _user.currentTrainingDay,
                              style: Theme.of(context).textTheme.display1,
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
                              height: 110,
                              child: Image(
                                  image: AssetImage('Images/ManMyPlan.jpg'),
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
