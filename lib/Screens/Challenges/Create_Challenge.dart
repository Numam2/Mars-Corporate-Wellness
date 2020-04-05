import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:wave_slider/wave_slider.dart';

class CreateChallenge extends StatefulWidget {
  @override
  _CreateChallengeState createState() => _CreateChallengeState();
}

class _CreateChallengeState extends State<CreateChallenge> {
  Future createChallenge(description, duration, start, completedDays) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return await Firestore.instance
        .collection('Challenges')
        .document(uid)
        .collection("My Challenges")
        .document(newChallenge)
        .setData({
      'Description': description,
      'Total Days': duration,
      'Last Checked': start,
      'Current Day': completedDays,
    });
  }

  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  Color _roundedButtonColor = Colors.black;
  String newChallenge;
  int duration = 0;
  String newDuration = '3';
  int startFromZero;


  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Container(
          height: 420,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment(1.0, 0.0),
                  child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close),
                      iconSize: 20.0),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 5),
                  child: Text(
                    "Create a challenge",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        border: Border.all(color: Colors.grey, width: 0.8)),
                    child: TextFormField(
                      style: GoogleFonts.montserrat(color: Colors.black, fontSize: 12),
                      validator: (val) =>
                          val.isEmpty ? "Please enter a description" : null,
                      cursorColor: Colors.redAccent[700],
                      decoration: InputDecoration.collapsed(
                        hintText: "Challenge Description",
                        hintStyle: TextStyle(color: Colors.grey.shade700),
                        // focusedBorder: UnderlineInputBorder(
                        //   borderSide: BorderSide(color: Colors.redAccent[700])
                        // )
                      ),
                      onChanged: (val) {
                        setState(() => newChallenge = val);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                //Duration
                Text(
                  '$newDuration days',
                  style: GoogleFonts.montserrat(fontSize: 12),
                ),
                Container(
                  height: 60,
                  width: 300,
                  child: WaveSlider(
                    color: Colors.black,
                    displayTrackball: true,
                    onChanged: (double dragUpdate) {
                      setState(() {
                        newDuration = ((dragUpdate * 11) + 3).toStringAsFixed(0); // dragUpdate is a fractional value between 0 and 1
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 250.0,
                  child: RoundedLoadingButton(
                    color: _roundedButtonColor,
                    child: Text('Create', style: GoogleFonts.montserrat(color: Colors.white,fontSize: 12)),
                    controller: _btnController,
                    onPressed: () async {
                      String lastcheck = '0';
                      int duration = int.parse(newDuration);
                      int currentDay = 0;
                      _roundedButtonColor = Colors.green;
                      Timer(Duration(seconds: 2), () {                        
                        _btnController.success();                        
                      });
                      await createChallenge(newChallenge, duration, lastcheck, currentDay);
                      Timer(Duration(seconds: 1), () {Navigator.of(context).pop();});
                    },
                    width: 200,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
