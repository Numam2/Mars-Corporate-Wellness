import 'dart:async';

import 'package:flutter/material.dart';
import 'package:personal_trainer/Screens/Challenges/ChallengeBloc.dart';
import 'package:personal_trainer/Screens/Challenges/Create_Challenge.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyChallenges extends StatefulWidget {
  @override
  _MyChallengesState createState() => _MyChallengesState();
}

  Future getUserChallenges() async {
    var firestore = Firestore.instance;
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    QuerySnapshot qn = await firestore
        .collection("Challenges")
        .document(uid)
        .collection("My Challenges")
        .getDocuments();
    return qn.documents;
  }

  Future getPopularChallenges() async {
    var firestore = Firestore.instance;
    QuerySnapshot qs = await firestore
        .collection("Challenges")
        .document("Challenge Recommendations")
        .collection("Challenges")
        .getDocuments();
    return qs.documents;
  }

  Future updateTodayStatus (todayDone, completedDays) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return await Firestore.instance.collection('Challenges').document(uid).collection("My Challenges").document(challenge).updateData({
     'Last Checked': todayDone,
     'Current Day': completedDays,
    });
  }

  Future completedChallenge (challenge, days, date) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return await Firestore.instance.collection('User Profile').document(uid).collection('Challenges').document(challengeDescription).setData({
     'Challenge': challenge,
     'Days': days,
     'Date': date,
    });
  }

  Future createChallenge (description, duration, start, completedDays) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return await Firestore.instance.collection('Challenges').document(uid).collection("My Challenges").document(challenge).setData({
     'Description': description,
     'Total Days': duration,
     'Last Checked': start,
     'Current Day': completedDays,
    });
  }

  // void _createCustomChallenge() async {
  //   Timer(Duration(seconds: 2), () {
  //     _btnController.success();    
  //     setState(() {
  //       _roundedButtonColor = Colors.green;
  //     });
  //   });
  //   await createChallenge(newChallenge, duration, startfromzero, startfromzero);
    
  //   Timer(Duration(seconds: 2), () {Navigator.of(context).pop();});
  // }

  // final RoundedLoadingButtonController _btnController =
  //     new RoundedLoadingButtonController();
  // Color _roundedButtonColor = Colors.black;
  // String newChallenge;
  // int duration = 0;
  // List<String> durations = [for(var i=1; i<15; i+=1) i.toString()];
  // String newDuration;
  // int startFromZero;

  var currentTime = DateTime.now();
  String today = currentTime.day.toString();

  Color _buttonColor = Colors.white;
  String challenge = '';
  var challengeDescription = '';

class _MyChallengesState extends State<MyChallenges> {
  
  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
        child: Container(
          //width: double.infinity,
          //height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:<Widget>[
              ///Daily Challenges Text
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: Row(
                  children:<Widget>[
                    Text(
                        "Today",
                        style: TextStyle(
                          fontSize: 25.0,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                        textAlign: TextAlign.start,
                      ),                    
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.add, color: Colors.redAccent[700], size: 30),
                      onPressed: (){
                        showDialog(
                          context: context,
                          builder: (context){
                            return CreateChallenge();
                          }
                        );
                      }
                    )
                  ] 
                ),
              ),
              SizedBox(height:25),
              ///Daily Challenges Cards
              FutureBuilder(
                future: getUserChallenges(),
                builder: (context, snapshot){
                  if (snapshot.connectionState == ConnectionState.waiting){
                    return Loading();
                  } else if (snapshot.data.length == 0){
                    return Center(
                      child: Text(
                        'You have no active challenges'
                      )
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context,index){

                        if (today == snapshot.data[index].data['Last Checked']){
                          _buttonColor = Colors.green;
                          return Padding(
                            padding: const EdgeInsets.only(bottom:12.0),
                            child: Container(
                              width: double.infinity,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: <BoxShadow> [
                                  new BoxShadow(
                                    color: Colors.black12,
                                    offset: new Offset(0.0, 10.0),
                                    blurRadius: 10.0,
                                  )
                                ]
                              ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20,5,20,5),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    //Check Box
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: InkWell(
                                        onTap: () async {
                                            challenge = snapshot.data[index].data['Description'];

                                            if (snapshot.data[index].data["Current Day"] > 0){

                                              var completedDays = snapshot.data[index].data["Current Day"] - 1;
                                              var currentTime = DateTime.now();
                                              DateTime yesterday = currentTime.subtract(new Duration(days: 1));
                                              String day = yesterday.day.toString();
                                                setState(() {
                                                  _buttonColor = Colors.white;                                              
                                                });
                                              await updateTodayStatus(day, completedDays);

                                            } else {

                                              var completedDays = snapshot.data[index].data["Current Day"];
                                              var currentTime = DateTime.now();
                                              DateTime yesterday = currentTime.subtract(new Duration(days: 1));
                                              String day = yesterday.day.toString();
                                                setState(() {
                                                  _buttonColor = Colors.white;
                                                });
                                                await updateTodayStatus(day, completedDays);
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
                                      ),
                                    ),
                                    SizedBox(width:15),
                                    //Text Column (Challenge name + date range + progress bar)
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:<Widget>[
                                        //Challenge description
                                        Text(
                                          snapshot.data[index].data['Description'],
                                          style: TextStyle(
                                            fontSize: 14, fontWeight: FontWeight.bold,
                                          color: Colors.black
                                          ),
                                        ),
                                        SizedBox(height:5),
                                        //Date range
                                        Text(
                                          'Done for Today  |  ' + snapshot.data[index].data['Current Day'].toString() + ' / ' + snapshot.data[index].data['Total Days'].toString() + ' days completed',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey
                                          ),
                                        ),
                                        SizedBox(height:15),
                                        //Progress indicator
                                        StepProgressIndicator(
                                          totalSteps: snapshot.data[index].data['Total Days'],
                                          currentStep: snapshot.data[index].data['Current Day'],
                                          fallbackLength: 175,
                                          selectedColor: Colors.green,
                                          unselectedColor: Colors.grey[300],
                                        )
                                      ]
                                    ),
                                    Spacer(),
                                    //Icon to delete challenge
                                    IconButton(
                                      icon: Icon(Icons.more_vert),
                                      alignment: Alignment.topRight,
                                      padding: EdgeInsets.only(top:8),
                                      iconSize: 20,
                                      onPressed: (){
                                        showDialog(
                                          context: context,
                                          builder: (context){
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15.0)),
                                              child: Container(
                                                height: 200,
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                                          "Forget this challenge?",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20.0,
                                                            fontFamily: "Roboto",
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 35,
                                                      ),
                                                      Container(
                                                        width: double.infinity,
                                                        alignment: Alignment.center,
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: <Widget>[
                                                            Container(
                                                                height: 35,
                                                                width: 100,
                                                                child: RaisedButton(
                                                                  onPressed: () async {                                                                    
                                                                    await Firestore.instance.runTransaction((Transaction myTransaction) async {
                                                                      await myTransaction.delete(snapshot.data[index].reference); //.document[index].reference);
                                                                      }
                                                                    );
                                                                    Timer(Duration(seconds: 1), () {    
                                                                      setState(() {
                                                                      });
                                                                    });
                                                                    Navigator.pop(context, MaterialPageRoute(builder: (context) => MyChallenges()));                                                                    
                                                                  },
                                                                  color: Colors.black,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(20),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Yes",
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(
                                                                          fontSize: 14, color: Colors.white),
                                                                    ),
                                                                  ),
                                                                )),
                                                            SizedBox(width: 20),
                                                            Container(
                                                                height: 35,
                                                                width: 100,
                                                                child: RaisedButton(
                                                                  onPressed: () => Navigator.pop(context),
                                                                  color: Colors.black,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(20),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "No",
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(
                                                                          fontSize: 14, color: Colors.white),
                                                                    ),
                                                                  ),
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        );
                                      } 
                                    ),
                                  ],
                                )
                              ),
                            ),
                          );

                        } else {
                          _buttonColor = Colors.white;
                          return Padding(
                            padding: const EdgeInsets.only(bottom:12.0),
                            child: Container(
                              width: double.infinity,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: <BoxShadow> [
                                  new BoxShadow(
                                    color: Colors.black12,
                                    offset: new Offset(0.0, 10.0),
                                    blurRadius: 10.0,
                                  )
                                ]
                              ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20,5,20,5),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[                                    
                                    //Check Box
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Material(
                                        color: Colors.white,
                                        child: InkWell(
                                          hoverColor: Colors.grey[200],
                                          highlightColor: Colors.grey[200],
                                          onTap: () async {
                                            var completedDays = snapshot.data[index].data["Current Day"] + 1;

                                            if(completedDays == snapshot.data[index].data["Total Days"]){                                              
                                              challenge = snapshot.data[index].data['Description'];
                                              challengeDescription = snapshot.data[index].data['Description'];
                                              int totalDays = snapshot.data[index].data['Total Days'];
                                              DateTime currentTime = DateTime.now();
                                              String today = currentTime.day.toString();
                                              print(today);                                             
                                              await completedChallenge (challengeDescription, totalDays, currentTime);
                                              await Firestore.instance.runTransaction((Transaction myTransaction) async {
                                                  await myTransaction.delete(snapshot.data[index].reference);
                                                }
                                              );
                                                setState(() {
                                                   Scaffold.of(context).showSnackBar(SnackBar(
                                                    content: Text('Congratulations on completing this challenge!', style: TextStyle(fontSize: 16)),
                                                    duration: Duration(seconds: 4),
                                                    backgroundColor: Colors.greenAccent[700],
                                                    elevation: 100,
                                                  ));
                                                });

                                            } else {
                                              challenge = snapshot.data[index].data['Description'];
                                              var currentTime = DateTime.now();
                                              String today = currentTime.day.toString();
                                                setState(() {
                                                });
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
                                        ),
                                      ),
                                    ),

                                    SizedBox(width:15),
                                    //Text Column (Challenge name + date range + progress bar)
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:<Widget>[
                                        //Challenge description
                                        Text(
                                          snapshot.data[index].data['Description'],
                                          style: TextStyle(
                                            fontSize: 14, fontWeight: FontWeight.bold,
                                          color: Colors.black
                                          ),
                                        ),
                                        SizedBox(height:5),
                                        //Date range
                                        Text(
                                          snapshot.data[index].data['Current Day'].toString() + ' / ' + snapshot.data[index].data['Total Days'].toString() + ' days completed',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey
                                          ),
                                        ),
                                        SizedBox(height:15),
                                        //Progress indicator
                                        StepProgressIndicator(
                                          totalSteps: snapshot.data[index].data['Total Days'],
                                          currentStep: snapshot.data[index].data['Current Day'],
                                          fallbackLength: 175,
                                          selectedColor: Colors.green,
                                          unselectedColor: Colors.grey[300],
                                        )
                                      ]
                                    ),
                                    
                                    Spacer(),
                                    //Icon to delete challenge
                                    IconButton(
                                      icon: Icon(Icons.more_vert),
                                      alignment: Alignment.topRight,
                                      padding: EdgeInsets.only(top:8),
                                      iconSize: 20,
                                      onPressed: (){
                                        showDialog(
                                          context: context,
                                          builder: (context){
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15.0)),
                                              child: Container(
                                                height: 200,
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                                      //Forget Challenge
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 15.0, right: 5),
                                                        child: Text(
                                                          "Forget this challenge?",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20.0,
                                                            fontFamily: "Roboto",
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 35,
                                                      ),
                                                      Container(
                                                        width: double.infinity,
                                                        alignment: Alignment.center,
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: <Widget>[
                                                            Container(
                                                                height: 35,
                                                                width: 100,
                                                                child: RaisedButton(
                                                                  onPressed: () async {                                                                    
                                                                    await Firestore.instance.runTransaction((Transaction myTransaction) async {
                                                                      await myTransaction.delete(snapshot.data[index].reference);
                                                                      }
                                                                    );
                                                                    // Timer(Duration(seconds: 1), () {    
                                                                      setState(() {
                                                                      });
                                                                    // });
                                                                    Navigator.pop(context, MaterialPageRoute(builder: (context) => MyChallenges()));                                                                    
                                                                  },
                                                                  color: Colors.black,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(20),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Yes",
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(
                                                                          fontSize: 14, color: Colors.white),
                                                                    ),
                                                                  ),
                                                                )),
                                                            SizedBox(width: 20),
                                                            Container(
                                                                height: 35,
                                                                width: 100,
                                                                child: RaisedButton(
                                                                  onPressed: () => Navigator.pop(context),
                                                                  color: Colors.black,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(20),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "No",
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(
                                                                          fontSize: 14, color: Colors.white),
                                                                    ),
                                                                  ),
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        );
                                      } 
                                    )
                                  ],
                                )
                              ),
                            ),
                          );

                        }                        
                                                
                      }
                    );
                  }
                }
              ),
              SizedBox(height:25),
              ///List of Challenges Text
              Padding(
                padding: const EdgeInsets.only(top:20.0),
                child: Text(
                  "Popular challenges",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height:25),
              ///List of Popular Challenges
              Container(
                height: 245,
                child: FutureBuilder(
                  future: getPopularChallenges(),
                  builder: (context, snapshot){
                    if (snapshot.connectionState == ConnectionState.waiting){
                      return Center();
                    } else{
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context,index){
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(10,0,10,12),
                            child: Container(
                              width: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: <BoxShadow> [
                                  new BoxShadow(
                                    color: Colors.black12,
                                    offset: new Offset(0.0, 10.0),
                                    blurRadius: 10.0,
                                  )
                                ]
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom:10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:<Widget>[
                                    //Image+ button
                                    Container(
                                      width: double.infinity,
                                      height: 160,                       
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8.0),
                                          topRight: Radius.circular(8.0)
                                        )
                                      ),
                                      child: Stack(
                                        children: <Widget>[
                                          //Image
                                          Image(
                                            image: AssetImage(snapshot.data[index].data['Image']),
                                            height: double.infinity,
                                            width: double.infinity,
                                            fit: BoxFit.cover
                                          ),
                                          //Icon to add challenge
                                          Padding(
                                            padding: const EdgeInsets.only(right:12.0),
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: IconButton(
                                                icon: Icon(Icons.add_circle, color: Colors.black),
                                                color: Colors.white,
                                                alignment: Alignment.topRight,
                                                padding: EdgeInsets.only(top:8),
                                                iconSize: 40,
                                                onPressed:() async {
                                                  challenge = snapshot.data[index].data['Description'];
                                                  String lastcheck = '';
                                                  int duration = snapshot.data[index].data['Total Days'];
                                                  int currentDay = 0;

                                                  await createChallenge(challenge, duration, lastcheck, currentDay);
                                                  setState(() {
                                                    _buttonColor = Colors.white;
                                                  });
                                                }
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //Challenge description
                                    Padding(
                                      padding: const EdgeInsets.only(right: 12, left:12.0, top:12),
                                      child: Text(
                                        snapshot.data[index].data['Description'],
                                        style: TextStyle(
                                          fontSize: 14, fontWeight: FontWeight.bold,
                                          color: Colors.black
                                        ),
                                      ),
                                    ),
                                    SizedBox(height:5),
                                    //Date range
                                    Padding(
                                      padding: const EdgeInsets.only(left:12.0),
                                      child: Text(
                                        snapshot.data[index].data['Total Days'].toString() + ' days',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey
                                        ),
                                      ),
                                    ),
                                  ]
                                )
                              ),
                            ),
                          );
                        }                
                      );
                    }                    
                  }                
                ),
              )
            ]
          ),
        ),
      ),
    );
  }
}