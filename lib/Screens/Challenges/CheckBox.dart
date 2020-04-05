import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_trainer/Models/challenge.dart';

class ChallengeCheckBox extends StatefulWidget {

  final Challenge chal;
  ChallengeCheckBox({this.chal});

  @override
  _ChallengeCheckBoxState createState() => _ChallengeCheckBoxState();
}

  var currentTime = DateTime.now();
  String today = currentTime.day.toString();

class _ChallengeCheckBoxState extends State<ChallengeCheckBox> {

  bool isButtonChecked = false;
  Color _buttonColor;
  String challenge;
  

  Future updateTodayStatus (todayDone, completedDays) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return await Firestore.instance.collection('Challenges').document(uid).collection("My Challenges").document(challenge).updateData({
     'Last Checked': todayDone,
     'Current Day': completedDays,
    });
  }

  @override
  Widget build(BuildContext context) {

    if (today == widget.chal.lastChecked){
      _buttonColor = Colors.green;
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
            await updateTodayStatus(today, completedDays);

            setState(() {
              _buttonColor = Colors.green;
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
    } 
  }
}