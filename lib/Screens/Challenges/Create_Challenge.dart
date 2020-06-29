import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/challenge.dart';
import 'package:personal_trainer/Screens/Challenges/PopularChallenges.dart';
import 'package:provider/provider.dart';

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
      'Created': DateTime.now(),
    });
  }

  String newChallenge;
  int duration = 5;
  String newDuration = '3';
  int startFromZero;

  double _value = 0.0;
  bool showErrorText = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.keyboard_arrow_left,
            color: Colors.black,
          ),
        ),
        title: Text(
          "Crea un hábito",
          style: Theme.of(context).textTheme.headline,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
            width: double.infinity,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                
                //Title
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text("Descripción",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.title),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        border: Border.all(color: Colors.grey, width: 0.8)),
                    child: TextFormField(
                      style: Theme.of(context).textTheme.body1,
                      validator: (val) => val.isEmpty
                          ? "No olvides agregar una descripción"
                          : null,
                      inputFormatters: [LengthLimitingTextInputFormatter(45)],
                      cursorColor: Theme.of(context).accentColor,
                      decoration: InputDecoration.collapsed(
                        hintText: "Descripción",
                        hintStyle: TextStyle(color: Colors.grey.shade700),
                      ),
                      onChanged: (val) {
                        setState(() => newChallenge = val);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),

                //Duration
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text("Duración: " + (_value + 5).toStringAsFixed(0) + ' días',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.title),
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Theme.of(context).accentColor,
                    inactiveTrackColor: Colors.grey[200],
                    trackShape: RoundedRectSliderTrackShape(),
                    trackHeight: 3.0,
                    thumbShape:
                        RoundSliderThumbShape(enabledThumbRadius: 12.0),
                    thumbColor: Theme.of(context).accentColor,
                    //overlayColor: Colors.grey[50],
                    overlayShape:
                        RoundSliderOverlayShape(overlayRadius: 28.0),
                    tickMarkShape: RoundSliderTickMarkShape(),
                    activeTickMarkColor: Theme.of(context).accentColor,
                    inactiveTickMarkColor: Colors.grey[200],
                    valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                    valueIndicatorColor: Theme.of(context).accentColor,
                    valueIndicatorTextStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  child: Slider(
                    min: 0,
                    max: 10,
                    divisions: 10,
                    value: _value,
                    label: (_value + 5).toStringAsFixed(0),
                    onChanged: (value) {
                      setState(() {
                        _value = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 30),

                ///Button
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 35.0,
                    child: RaisedButton(
                      onPressed: () async {

                        if (newChallenge != null){
                          String lastcheck = '0';
                          int duration = (_value + 5).round();
                          int currentDay = 0;
                          await createChallenge(
                              newChallenge, duration, lastcheck, currentDay);
                          Navigator.of(context).pop();
                        } else {
                          setState(() {
                            showErrorText = true; 
                          });
                        }
                        
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).accentColor,
                              Theme.of(context).primaryColor
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth: 200.0, minHeight: 50.0),
                          alignment: Alignment.center,
                          child: Text(
                            "GUARDAR META",
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
                ),
                SizedBox(height: 10),
                showErrorText 
                ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'No olvides agregar una descripción',
                    style: GoogleFonts.montserrat(
                      color: Colors.redAccent[700],
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                    )
                  )
                )
                : SizedBox(),
                
                SizedBox(height: 10),

                //Popular Challenges
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Hábitos recomendados",
                    style: Theme.of(context).textTheme.title,
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(height: 5),
                StreamProvider<List<PopularChallenges>>.value(
                  value: DatabaseService().popularChallengeList,
                  child: PopularChallengeList(displayOnHome: false),
                ),
                SizedBox(height: 25),
              ],
            )),

      ),
    );
  }
}
