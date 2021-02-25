import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Firebase_Services/levelTracker.dart';
import 'package:personal_trainer/Models/goals.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Shared/RecognitionGoal.dart';
import 'package:personal_trainer/Shared/RecognitionLevelUp.dart';
import 'package:provider/provider.dart';

class GoalUpdate extends StatefulWidget {
  final Goals goal;
  final bool loseWeight;
  final double currentVal;
  GoalUpdate({this.goal, this.loseWeight, this.currentVal});

  @override
  _GoalUpdateState createState() => _GoalUpdateState();
}

class _GoalUpdateState extends State<GoalUpdate> {

  String currentValue;
  final _formKey = GlobalKey<FormState>();
  String error = '';
  double currentVal;

  @override
  void initState() {
    currentVal = widget.currentVal;
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {

    final _profile = Provider.of<UserProfile>(context);    

    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ///Horizontal Scroll Line
            Padding(
              padding: EdgeInsets.only(top: 3.0),
              child: Icon(Icons.remove,
                  size: 30, color: Theme.of(context).canvasColor),
            ),
            //title
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Actualiza tu peso actual",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.title,
              ),
            ),

            SizedBox(
              height: 35,
            ),
            ///Change Weight
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //Substract button
                IconButton(
                  icon: Icon(Icons.remove_circle_outline), 
                  onPressed: (){
                    setState(() {
                      currentVal = currentVal - 0.1;
                      currentValue = currentVal.toString();
                    });
                    
                  }
                ),
                SizedBox(width: 20),
                ///Weight
                Text(
                  currentVal.toStringAsFixed(1),
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w400),
                ),
                SizedBox(width: 20),                
                //Add button
                IconButton(
                  icon: Icon(Icons.add_circle_outline), 
                  onPressed: (){
                    setState(() {
                      currentVal = currentVal + 0.1;
                      currentValue = currentVal.toString();
                    });
                  }
                ),
              ],
            ),
            SizedBox(
              height: 35,
            ),

            Container(
              height: 35.0,
              width: 200,
              child: RaisedButton(
                onPressed: () async {
                  if (currentValue.contains(',')) {
                    setState(() => error =
                        "Asegúrate de agregar los decimales con punto, no con coma");
                  } else {
                    var newVal = double.tryParse(currentValue);
                    //Earn 150 pts for completing the goal
                    var pointsCounter = (_profile.points + (150)).round();

                    ///////////////////////////// Goal is Losing Weight ////////////////////////
                    if(!widget.loseWeight){

                      //If I am completing the goal
                      if (newVal >= widget.goal.targetValue) {
                        //if I should move to next level
                        if (pointsCounter > _profile.levelTo) {
                          var duration = (DateTime.now()
                                      .difference(widget.goal.dateFrom)
                                      .inDays)
                                  .toString() +
                              ' días';
                          DatabaseService().updateUserPoints(pointsCounter);
                          LevelTracker().updateLevel(_profile.levelTo);
                          DatabaseService().saveTrainingSession(
                              widget.goal.description, duration, 'Meta');
                          DatabaseService().updateGoalProgress(
                              widget.goal.description, newVal);
                          DatabaseService().recordOrganizationStats(_profile.organization, 'Goals Achieved');
                          Navigator.push(context,
                                MaterialPageRoute(builder: (context) => ReconitionLevelUp(
                                  level: _profile.level,
                                  points: pointsCounter,
                                  headline: '¡Subí al ' + _profile.level + '!',
                                  time: pointsCounter.toString() + ' PTS',
                                  organization: _profile.organization
                                )));
                        }
                        //If I only accumulate points
                        else {
                          var duration = (DateTime.now()
                                      .difference(widget.goal.dateFrom)
                                      .inDays)
                                  .toString() +
                              ' días';
                          print(duration);
                          DatabaseService().updateUserPoints(pointsCounter);
                          DatabaseService().saveTrainingSession(
                              widget.goal.description, duration, 'Meta');
                          DatabaseService().updateGoalProgress(
                              widget.goal.description, newVal);
                          DatabaseService().recordOrganizationStats(_profile.organization, 'Goals Achieved');
                          Navigator.push(context,
                                MaterialPageRoute(builder: (context) => ReconitionGoal(
                                  headline: 'Alcancé una meta: ' + widget.goal.description,
                                  time: duration,
                                  organization: _profile.organization
                                )));
                        }
                        ///If only update weigth
                      } else {
                        DatabaseService().updateGoalProgress(
                            widget.goal.description, newVal);
                        Navigator.of(context).pop();
                      }
                    
                    ///////////////////////////// Goal is Gain Weight ////////////////////////
                    } else {

                      //If I am completing the goal
                      if (newVal <= widget.goal.targetValue) {
                        //if I should move to next level
                        if (pointsCounter > _profile.levelTo) {
                          var duration = (DateTime.now()
                                      .difference(widget.goal.dateFrom)
                                      .inDays)
                                  .toString() +
                              ' días';
                          print(duration);
                          DatabaseService().updateUserPoints(pointsCounter);
                          LevelTracker().updateLevel(_profile.levelTo);
                          DatabaseService().saveTrainingSession(
                              widget.goal.description, duration, 'Meta');
                          DatabaseService().updateGoalProgress(
                              widget.goal.description, newVal);
                          DatabaseService().recordOrganizationStats(_profile.organization, 'Goals Achieved');
                          Navigator.push(context,
                                MaterialPageRoute(builder: (context) => ReconitionLevelUp(
                                  level: _profile.level,
                                  points: pointsCounter,
                                  headline: '¡Subí al ' + _profile.level + '!',
                                  time: pointsCounter.toString() + ' PTS',
                                  organization: _profile.organization
                                )));
                        }
                        //If I only accumulate points
                        else {
                          var duration = (DateTime.now()
                                      .difference(widget.goal.dateFrom)
                                      .inDays)
                                  .toString() +
                              ' días';
                          print(duration);
                          DatabaseService().updateUserPoints(pointsCounter);
                          DatabaseService().saveTrainingSession(
                              widget.goal.description, duration, 'Meta');
                          DatabaseService().updateGoalProgress(
                              widget.goal.description, newVal);
                          DatabaseService().recordOrganizationStats(_profile.organization, 'Goals Achieved');
                          Navigator.push(context,
                                MaterialPageRoute(builder: (context) => ReconitionGoal(
                                  headline: 'Alcancé una meta: ' + widget.goal.description,
                                  time: duration,
                                  organization: _profile.organization
                                )));
                        }
                        ///If only update weigth
                      } else {
                        DatabaseService().updateGoalProgress(
                            widget.goal.description, newVal);
                        Navigator.of(context).pop();
                      }

                    }
                      
                    
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Container(
                    constraints:
                        BoxConstraints(maxWidth: 200.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Text(
                      "ACTUALIZAR",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 10.0),
            Text(
              error,
              style:
                  GoogleFonts.montserrat(color: Colors.red, fontSize: 14.0),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
