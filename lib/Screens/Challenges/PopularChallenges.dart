import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Screens/Challenges/Create_Challenge.dart';
import 'package:provider/provider.dart';
import 'package:personal_trainer/Models/challenge.dart';

class PopularChallengeList extends StatefulWidget {
  final bool displayOnHome;
  PopularChallengeList({this.displayOnHome});

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
      'Created': DateTime.now(),
    });
  }

  String challenge = '';

  @override
  Widget build(BuildContext context) {
    final _popularChallenge = Provider.of<List<PopularChallenges>>(context);

    if (_popularChallenge == null || _popularChallenge.length == null) {
      return Container(
        constraints: BoxConstraints(maxHeight: 170),
        child: ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Container(
                  width: 150,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //Image+ button
                        Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              color: Colors.grey[300]),
                        ),
                        //Challenge description
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Container(
                            width: 70,
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              color: Colors.grey[200],
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        //Date range
                        Container(
                          width: 50,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            color: Colors.grey[100],
                          ),
                        ),
                      ]),
                ),
              );
            }),
      );
    } else if (widget.displayOnHome) {
      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
            child: Row(children: <Widget>[
              Text(
                "Adopta un hábito",
                style: Theme.of(context).textTheme.title,
                textAlign: TextAlign.start,
              ),
              Spacer(),
              IconButton(
                  icon: Icon(Icons.add,
                      color: Theme.of(context).primaryColor, size: 30),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateChallenge()));
                  })
            ]),
          ),
          Container(
            constraints: BoxConstraints(maxHeight: 170),
            child: ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: _popularChallenge.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: (index == _popularChallenge.length - 1)
                        ? EdgeInsets.symmetric(horizontal: 20)
                        : EdgeInsets.only(left: 20),
                    child: Container(
                      width: 150,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            //Image+ button
                            Container(
                              width: double.infinity,
                              height: 100,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          _popularChallenge[index].image),
                                      fit: BoxFit.cover)),
                              child: Padding(
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
                                        challenge = _popularChallenge[index]
                                            .description;
                                        String lastcheck = '';
                                        int duration =
                                            _popularChallenge[index].totalDays;
                                        int currentDay = 0;
                                        if (widget.displayOnHome) {
                                          await createChallenge(challenge,
                                              duration, lastcheck, currentDay);
                                        } else {
                                          Navigator.of(context).pop();
                                          await createChallenge(challenge,
                                              duration, lastcheck, currentDay);
                                        }
                                      }),
                                ),
                              ),
                            ),
                            //Challenge description
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                _popularChallenge[index].description,
                                style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ),
                            SizedBox(height: 5),
                            //Date range
                            Text(
                              _popularChallenge[index].totalDays.toString() +
                                  ' dias',
                              style: GoogleFonts.montserrat(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w200,
                                  color: Colors.black),
                            ),
                          ]),
                    ),
                  );
                }),
          )
        ],
      );
    }

    return Container(
      constraints: BoxConstraints(maxHeight: 170),
      child: ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: _popularChallenge.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: (index == _popularChallenge.length - 1)
                  ? EdgeInsets.symmetric(horizontal: 20)
                  : EdgeInsets.only(left: 20),
              child: Container(
                width: 150,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //Image+ button
                      Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            image: DecorationImage(
                                image:
                                    AssetImage(_popularChallenge[index].image),
                                fit: BoxFit.cover)),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                                icon:
                                    Icon(Icons.add_circle, color: Colors.black),
                                color: Colors.white,
                                alignment: Alignment.topRight,
                                padding: EdgeInsets.only(top: 8),
                                iconSize: 40,
                                onPressed: () async {
                                  challenge =
                                      _popularChallenge[index].description;
                                  String lastcheck = '';
                                  int duration =
                                      _popularChallenge[index].totalDays;
                                  int currentDay = 0;
                                  if (widget.displayOnHome) {
                                    await createChallenge(challenge, duration,
                                        lastcheck, currentDay);
                                  } else {
                                    Navigator.of(context).pop();
                                    await createChallenge(challenge, duration,
                                        lastcheck, currentDay);
                                  }
                                }),
                          ),
                        ),
                      ),
                      //Challenge description
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          _popularChallenge[index].description,
                          style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 5),
                      //Date range
                      Text(
                        _popularChallenge[index].totalDays.toString() + ' dias',
                        style: GoogleFonts.montserrat(
                            fontSize: 11,
                            fontWeight: FontWeight.w200,
                            color: Colors.black),
                      ),
                    ]),
              ),
            );
          }),
    );
  }
}
