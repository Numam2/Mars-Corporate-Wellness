import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Firebase_Services/levelTracker.dart';
import 'package:personal_trainer/Models/goals.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Shared/RecognitionGoal.dart';
import 'package:personal_trainer/Shared/RecognitionLevelUp.dart';
import 'package:provider/provider.dart';

//DatabaseService().updateGoalProgress(goal, currentValue)

class GoalUpdateMilestones extends StatefulWidget {
  final Goals goal;
  GoalUpdateMilestones({this.goal});

  @override
  _GoalUpdateMilestonesState createState() => _GoalUpdateMilestonesState();
}

class _GoalUpdateMilestonesState extends State<GoalUpdateMilestones> {
  int currentValue = 0;
  final _formKey = GlobalKey<FormState>();
  String error = '';
  
  @override
  Widget build(BuildContext context) {
    final _profile = Provider.of<UserProfile>(context);

    List<Milestones> milestoneList = List.from(widget.goal.milestones);
    List newMilestoneList = [];          

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

            ///Title
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75),
                child: Text(
                  widget.goal.description,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.title,
                ),
              ),
            ),

            ///List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                  width: double.infinity,
                  child: ListView.builder(
                      itemCount: milestoneList.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                //Send
                                InkWell(
                                    onTap: () async {
                                      setState(() {
                                        milestoneList[index].complete =
                                            !milestoneList[index].complete;
                                      });
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        color: milestoneList[index].complete
                                            ? Theme.of(context).accentColor
                                            : Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.fromBorderSide(
                                            BorderSide(
                                                color: Colors.grey,
                                                width: 0.5)),
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    )),
                                SizedBox(width: 20),
                                //Milestone
                                Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.6),
                                  child: Text(
                                    milestoneList[index].description,
                                    style: Theme.of(context).textTheme.body1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })),
            ),

            SizedBox(
              height: 30,
            ),

            ///Button
            Container(
              height: 35.0,
              width: 200,
              child: RaisedButton(
                onPressed: () async {

                  var finishedGoal = milestoneList.every((milestone) => milestone.complete == true);                    

                  milestoneList.forEach((x){
                    newMilestoneList.add({
                        'Milestone': x.description,
                        'Complete': x.complete,
                    });
                    if (x.complete == true){
                      currentValue = currentValue + 1;
                    }
                  });

                  //Earn 150 pts for completing the goal
                  var pointsCounter = (_profile.points + (150)).round();

                  //If I am completing the goal
                  if (finishedGoal == true) {
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
                      DatabaseService().updateMilestone(
                          widget.goal.description, newMilestoneList);
                      DatabaseService().updateGoalProgress(widget.goal.description, currentValue);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReconitionLevelUp(
                                    level: _profile.level,
                                    points: pointsCounter,
                                    headline:
                                        '¡Subí al ' + _profile.level + '!',
                                    time: pointsCounter.toString() + ' PTS',
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
                      DatabaseService().updateMilestone(
                          widget.goal.description, newMilestoneList);
                      DatabaseService().updateGoalProgress(widget.goal.description, currentValue);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReconitionGoal(
                                    headline: 'Alcancé una meta: ' +
                                        widget.goal.description,
                                    time: duration + ' DÍAS',
                                  )));
                    }
                  } else {
                    DatabaseService().updateMilestone(
                          widget.goal.description, newMilestoneList);
                    DatabaseService().updateGoalProgress(widget.goal.description, currentValue);
                    Navigator.of(context).pop();
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
