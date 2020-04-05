import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:personal_trainer/Models/challenge.dart';

class PopularChallengeList extends StatefulWidget {
  @override
  _PopularChallengeListState createState() => _PopularChallengeListState();
}

class _PopularChallengeListState extends State<PopularChallengeList> {
  
  Future createChallenge(description, duration, start, completedDays) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return await Firestore.instance
        .collection('Challenges')
        .document(uid)
        .collection("My Challenges")
        .document(challenge)
        .setData({
      'Description': description,
      'Total Days': duration,
      'Last Checked': start,
      'Current Day': completedDays,
    });
  }

  String challenge = '';

  @override
  Widget build(BuildContext context) {

    final _popularChallenge = Provider.of<List<PopularChallenges>>(context);

    return Container(
      height: 255,
      child: ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: <BoxShadow>[
                      new BoxShadow(
                        color: Colors.black12,
                        offset: new Offset(0.0, 10.0),
                        blurRadius: 10.0,
                      )
                    ]),
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //Image+ button
                          Container(
                            width: double.infinity,
                            height: 160,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(8.0))),
                            child: Stack(
                              children: <Widget>[
                                //Image
                                Image(
                                    image: AssetImage(
                                      _popularChallenge[index].image),
                                    height: double.infinity,
                                    width: double.infinity,
                                    fit: BoxFit.cover),
                                //Icon to add challenge
                                Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                        icon: Icon(Icons.add_circle,
                                            color: Colors.black),
                                        color: Colors.white,
                                        alignment: Alignment.topRight,
                                        padding: EdgeInsets.only(top: 8),
                                        iconSize: 40,
                                        onPressed: () async {
                                          challenge = _popularChallenge[index].description;
                                          String lastcheck = '';
                                          int duration = _popularChallenge[index].totalDays;
                                          int currentDay = 0;
                                          await createChallenge(challenge, duration, lastcheck, currentDay);
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //Challenge description
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 12, left: 12.0, top: 12),
                            child: Text(
                              _popularChallenge[index].description,
                              style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                          SizedBox(height: 5),
                          //Date range
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                              _popularChallenge[index].totalDays.toString() + ' days',
                              style: GoogleFonts.montserrat(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w200,
                                  color: Colors.black),
                            ),
                          ),
                        ])),
              ),
            );
          }),
    );
  }
}
