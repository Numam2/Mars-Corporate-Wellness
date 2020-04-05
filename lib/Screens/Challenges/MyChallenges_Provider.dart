import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Models/challenge.dart';
import 'package:personal_trainer/Screens/Challenges/Create_Challenge.dart';
import 'package:personal_trainer/Screens/Challenges/PopularChallenges.dart';
import 'package:personal_trainer/Screens/Challenges/myChallengeList.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:provider/provider.dart';


class MyChallengesProvider extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    final _challenges = Provider.of<List<Challenge>>(context);
    final _popularChallenge = Provider.of<List<PopularChallenges>>(context);

    if (_challenges == null || _popularChallenge == null){
      return Center(
        child: Loading()
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:<Widget>[
              ///Daily Challenges Text
              Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10),
                child: Row(
                  children:<Widget>[
                    Text(
                        "Today's challenges",
                        style: GoogleFonts.montserrat(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
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
              SizedBox(height:5),
              ///Daily Challenges Cards
              ChallengeList(),
              ///List of Challenges Text
              Padding(
                padding: const EdgeInsets.only(top:30.0),
                child: Text(
                  "Popular challenges",
                  style: GoogleFonts.montserrat(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height:25),
              ///List of Popular Challenges
              PopularChallengeList(),
            ]
          ),
        ),
      ),
    );
  }
}