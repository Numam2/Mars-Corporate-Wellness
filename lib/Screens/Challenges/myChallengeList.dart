import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Models/challenge.dart';
import 'package:personal_trainer/Screens/Challenges/CheckBox.dart';
import 'package:personal_trainer/Screens/Challenges/DeleteChallenge.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ChallengeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    final _challenges = Provider.of<List<Challenge>>(context);

    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _challenges.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Container(
                height: 100,
                width: double.infinity,
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
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Row(children: <Widget>[
                      //Check Box
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ChallengeCheckBox(chal: _challenges[index]),
                      ),
                      SizedBox(width: 15),
                      //Text Column (Challenge name + date range + progress bar)
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            //Challenge description
                            Text(
                              _challenges[index].description,
                              style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            SizedBox(height: 5),
                            //Date range
                            Text(
                              'Done for Today  |  ' +
                                  _challenges[index].currentDay.toString() +
                                  ' / ' +
                                  _challenges[index].totalDays.toString() +
                                  ' days completed',
                              style: GoogleFonts.montserrat(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w200,
                                  color: Colors.black),
                            ),
                            SizedBox(height: 15),
                            //Progress indicator
                            StepProgressIndicator(
                              totalSteps: _challenges[index].totalDays,
                              currentStep: _challenges[index].currentDay,
                              fallbackLength: 175,
                              selectedColor: Colors.green,
                              unselectedColor: Colors.grey[300],
                            )
                          ]),
                      Spacer(),
                      //Icon to delete challenge
                      IconButton(
                          icon: Icon(Icons.more_vert),
                          alignment: Alignment.topRight,
                          padding: EdgeInsets.only(top: 8),
                          iconSize: 20,
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return DeleteChallenge(
                                      challengeDescription:
                                          _challenges[index].description);
                                });
                          }),
                    ])),
              ),
            );
          }),
    );
  }
}
