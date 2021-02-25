import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Firebase_Services/levelTracker.dart';
import 'package:personal_trainer/Models/challenge.dart';
import 'package:personal_trainer/Models/dates.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Shared/RecognitionHabitChallenge.dart';
import 'package:personal_trainer/Shared/RecognitionLevelUp.dart';
import 'package:provider/provider.dart';

class ChallengeCheckBox extends StatefulWidget {

  final Challenge chal;
  ChallengeCheckBox({this.chal});

  @override
  _ChallengeCheckBoxState createState() => _ChallengeCheckBoxState();
}

class _ChallengeCheckBoxState extends State<ChallengeCheckBox> {

  bool isButtonChecked = false;
  Color _buttonColor;
  String challenge;
  

  Future updateTodayStatus (todayDone, completedDays) async {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    return await FirebaseFirestore.instance.collection('Challenges').doc(uid).collection("My Challenges").doc(challenge).update({
     'Last Checked': todayDone,
     'Current Day': completedDays,
    });
  }

  Future saveCompletedChallenge (challenge, days, date) async {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    return await FirebaseFirestore.instance.collection('User Profile').doc(uid).collection("Challenges").doc(challenge).set({
     'Challenge': challenge,
     'Days': days,
     'Date': date,
    });
  }

  Future deleteChallenge () async {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    return await FirebaseFirestore.instance.collection('Challenges').doc(uid).collection("My Challenges").doc(challenge).delete();
  }

  DateTime currentTime;
  String today;

  @override
  void initState() {
    currentTime = DateTime.now();
    today = currentTime.day.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final _profile = Provider.of<UserProfile>(context);

  
    if (today == widget.chal.lastChecked){
      _buttonColor = Theme.of(context).accentColor;
      return InkWell(
        onTap: () async {

            var completedDays = widget.chal.currentDay - 1;
            challenge = widget.chal.description;
            DateTime yesterday = currentTime.subtract(new Duration(days: 1));
            String day = yesterday.day.toString();      
            await updateTodayStatus(day, completedDays);
            
            setState(() {
              _buttonColor = Colors.white;
            });
          
        },
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: _buttonColor,
            shape: BoxShape.circle,
            border: Border.fromBorderSide(BorderSide(color:Colors.grey, width: 0.5)),                          
          ),
          child: Icon(
            Icons.check,
            size: 20,
            color: Colors.white,
          ),
        )
      );
    } else {
      _buttonColor = Colors.white;
      return InkWell(
        onTap: () async {

            var completedDays = widget.chal.currentDay + 1;
            challenge = widget.chal.description;
            var pointsCounter = (_profile.points + (widget.chal.totalDays * 2)).round();

            /////Logic to record challenge updates
            if(_profile.activeOrganizationChallenges == {} || _profile.activeOrganizationChallenges == null){
              //Do nothing
            } else {
              if(_profile.activeOrganizationChallenges['Status'] == 'Completo' || DateTime.now().difference(_profile.activeOrganizationChallenges['Date Finish'].toDate()).inDays > 0){
                //Do nothing
              } else if(_profile.activeOrganizationChallenges['Type'] ==  'Habit Count'){
                //If next to complete
                if(_profile.activeOrganizationChallenges['Completed Steps'] + 1 == _profile.activeOrganizationChallenges['Target']){
                  DatabaseService().updateOrgChallenge('Completo', _profile.activeOrganizationChallenges['Completed Steps'] + 1);
                  DatabaseService().saveTrainingSession('Reto', DatesDictionary().monthDictionary[_profile.activeOrganizationChallenges['Date Finish'].month - 1], _profile.activeOrganizationChallenges['Challenge Title']);
                  DatabaseService().updateChallengeCompletedCount(_profile.organization,_profile.activeOrganizationChallenges['Challenge ID']);
                  DatabaseService().recordOrganizationStats(_profile.organization, 'Challenges Completed');
                } else {
                  DatabaseService().updateOrgChallenge('En Progreso', _profile.activeOrganizationChallenges['Completed Steps'] + 1);
                }
              }             
            }

            /// Logic to increase level or not
            if (completedDays == widget.chal.totalDays){              

              if(pointsCounter > _profile.levelTo){
                DatabaseService().updateUserPoints(pointsCounter);
                LevelTracker().updateLevel(_profile.levelTo);
                DatabaseService().saveTrainingSession(challenge, widget.chal.totalDays.toString() + ' días', 'Hábito');
                deleteChallenge();
                DatabaseService().recordOrganizationStats(_profile.organization, 'Habits Adopted');
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ReconitionLevelUp(
                    level: _profile.level,
                    points: pointsCounter,
                    headline: '¡Subí al ' + _profile.level + '!',
                    time: pointsCounter.toString() + ' PTS',
                    organization: _profile.organization
                  )));
              } else {
                DatabaseService().updateUserPoints(pointsCounter);
                DatabaseService().saveTrainingSession(challenge, widget.chal.totalDays.toString() + ' días', 'Hábito');
                deleteChallenge();
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ReconitionHabitChallenge(
                     headline: 'Completé un hábito: ' + challenge,
                    time: widget.chal.totalDays.toString() + ' DÍAS',
                    organization: _profile.organization
                  )));
              }
            } else {
              await updateTodayStatus(today, completedDays);
            }
            
        },
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: _buttonColor,
            shape: BoxShape.circle,
            border: Border.fromBorderSide(BorderSide(color:Colors.grey, width: 0.5)),                          
          ),
          child: Icon(
            Icons.check,
            size: 20,
            color: Colors.white,
          ),
        )
      );
    } 
  }
}