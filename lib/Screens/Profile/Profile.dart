import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_trainer/Screens/Profile/Onboarding.dart';
import 'package:personal_trainer/Shared/Loading.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //////// Create a future that retrieves Firestore data for Weeks collection
  Future getUserProfile() async {
    var firestore = Firestore.instance;
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    DocumentSnapshot docRef =
        await firestore.collection("User Profile").document(uid).get();
    return docRef.data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Loading()
            );
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data["Preference"] == "None" || snapshot.data["Preference"] == "") {
            return Onboarding();
          } else {
            return Scaffold(
              body: Container(
                //color: Colors.red,
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    //Green Container with Name and Data
                    Container(
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade900,
                          //borderRadius: BorderRadius.only(bottomLeft:Radius.circular(70),bottomRight:Radius.circular(70)),
                          boxShadow: <BoxShadow>[
                            new BoxShadow(
                              color: Colors.black12,
                              offset: new Offset(5.0, 10.0),
                              blurRadius: 10.0,
                            )
                          ]),
                      child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              //Name
                              Container(
                                child: Text(
                                  'Hi ' + snapshot.data["Name"] + '!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 35.0,
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              SizedBox(height: 40),
                              //Age-weight,height
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  ///Age
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        snapshot.data["Age"],
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Age',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white60),
                                      )
                                    ],
                                  ),
                                  SizedBox(width: 50),

                                  ///Height
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        snapshot.data["Height"],
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Cm',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white60),
                                      )
                                    ],
                                  ),
                                  SizedBox(width: 50),

                                  ///Weight
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        snapshot.data["Weight"],
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Kg',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white60),
                                      )
                                    ],
                                  ),
                                ],
                              )
                            ]),
                      ),
                    ),
                    //Goal and experience
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
                      child: Container(
                        height: 80,
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            snapshot.data["Experience"] +
                                " and I want to " +
                                snapshot.data["Goal"],
                            style: TextStyle(fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    //Metrics
                    Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ///Workouts
                           Container(
                            width:110,
                            //height: 110,
                            padding: EdgeInsets.all(15),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Icon(
                                    Icons.check,
                                    size: 20,
                                    color: Colors.redAccent[700],
                                    //Icons.whatshot
                                  ),
                                ),
                                SizedBox(height:7),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                     Text(
                                      snapshot.data["Accumulated Workouts"].toString(),
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    SizedBox(height: 10),         
                                    Text(
                                      'Workouts',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black,wordSpacing: 30),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 15),
                          ///Hours
                           Container(
                            width:110,
                            //height: 110,
                            padding: EdgeInsets.all(15),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Icon(
                                    Icons.access_time,
                                    size: 20,
                                    color: Colors.redAccent[700],
                                  ),
                                ),
                                SizedBox(height:7),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                     Text(
                                       snapshot.data["Accumulated Hours"].toString(),
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    SizedBox(height: 10),         
                                    Text(
                                      'Hours',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black,wordSpacing: 30),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(width:15),
                          ///Calories
                          Container(
                            width:110,
                            //height: 110,
                            padding: EdgeInsets.all(15),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Icon(
                                    Icons.whatshot,
                                    size: 20,
                                    color: Colors.redAccent[700],
                                    //Icons.whatshot
                                  ),
                                ),
                                SizedBox(height:7),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                     Text(
                                      snapshot.data["Calories Burnt"].toString(),
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    SizedBox(height: 10),         
                                    Text(
                                      'Calories',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black,wordSpacing: 30),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),

                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        } //End if statement
        );
  }
}
