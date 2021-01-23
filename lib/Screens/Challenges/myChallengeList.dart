import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/challenge.dart';
import 'package:personal_trainer/Screens/Challenges/CheckBox.dart';
import 'package:personal_trainer/Screens/Challenges/Create_Challenge.dart';
import 'package:personal_trainer/Screens/Challenges/DeleteChallenge.dart';
import 'package:personal_trainer/Screens/Challenges/PopularChallenges.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ChallengeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _challenges = Provider.of<List<Challenge>>(context);

    if (_challenges == null) {
      return SizedBox();
    } else if (_challenges.length == 0) {
      return PopularChallengeList(displayOnHome: true);
    }
    
    return Column(
      children: <Widget>[
        //Title
        Padding(
          padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
          child: Row(children: <Widget>[
            Text(
              "Mis hábitos",
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
        //List
        Container(
          padding: EdgeInsets.only(bottom: 20),
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _challenges.length,
              itemBuilder: (context, index) {

                if((DateTime.now().difference(_challenges[index].created).inDays).round() > _challenges[index].totalDays){
                  return Slidable(
                    actionPane: SlidableStrechActionPane(),
                    actionExtentRatio: 0.25,
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        color: Colors.white,
                        iconWidget: Icon(Icons.delete, color: Colors.black),
                        onTap: () {
                          return showDialog(
                              context: context,
                              builder: (context) {
                                return DeleteChallenge(
                                    challengeDescription:
                                        _challenges[index].description);
                              });
                        },
                      ),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 12.0),
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: <BoxShadow>[
                              new BoxShadow(
                                color: Colors.grey[350],
                                offset: new Offset(0.0, 3.0),
                                blurRadius: 5.0,
                              )
                            ]),
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                            child: Row(children: <Widget>[
                              //Check Box
                              Align(
                                alignment: Alignment.centerLeft,
                                child:
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).disabledColor,
                                        shape: BoxShape.circle,
                                        border: Border.fromBorderSide(BorderSide(color:Colors.grey, width: 0.5)),                          
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                              ),
                              SizedBox(width: 15),
                              //Text Column (Challenge name + date range + progress bar)
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    //Challenge description
                                    Container(
                                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.6),
                                      child: Text(_challenges[index].description,
                                          style: GoogleFonts.montserrat(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context).canvasColor)
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    //Date range
                                    Text(
                                        'Pasaste el límite de tiempo',
                                        style:
                                            Theme.of(context).textTheme.display2),
                                    SizedBox(height: 15),
                                    //Progress indicator
                                    StepProgressIndicator(
                                        totalSteps: _challenges[index].totalDays,
                                        currentStep:
                                            _challenges[index].currentDay,
                                        fallbackLength: 175,
                                        selectedColor:
                                            Theme.of(context).canvasColor,
                                        unselectedColor:
                                            Theme.of(context).disabledColor)
                                  ]),
                            ])),
                      ),
                    ),
                  );
                }

                return Slidable(
                  actionPane: SlidableStrechActionPane(),
                  actionExtentRatio: 0.25,
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      color: Colors.white,
                      iconWidget: Icon(Icons.delete, color: Colors.black),
                      onTap: () {
                        return showDialog(
                            context: context,
                            builder: (context) {
                              return DeleteChallenge(
                                  challengeDescription:
                                      _challenges[index].description);
                            });
                      },
                    ),
                  ],
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 12.0),
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: <BoxShadow>[
                            new BoxShadow(
                              color: Colors.grey[350],
                              offset: new Offset(0.0, 3.0),
                              blurRadius: 5.0,
                            )
                          ]),
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: Row(children: <Widget>[
                            //Check Box
                            Align(
                              alignment: Alignment.centerLeft,
                              child:
                                  ChallengeCheckBox(chal: _challenges[index]),
                            ),
                            SizedBox(width: 15),
                            //Text Column (Challenge name + date range + progress bar)
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  //Challenge description
                                  Container(
                                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.6),
                                    child: Text(_challenges[index].description,
                                        style:
                                          Theme.of(context).textTheme.display1),
                                  ),
                                  SizedBox(height: 5),
                                  //Date range
                                  Text(
                                      _challenges[index].currentDay.toString() +
                                          ' / ' +
                                          _challenges[index]
                                              .totalDays
                                              .toString() +
                                          ' días completos',
                                      style:
                                          Theme.of(context).textTheme.display2),
                                  SizedBox(height: 15),
                                  //Progress indicator
                                  StepProgressIndicator(
                                      totalSteps: _challenges[index].totalDays,
                                      currentStep:
                                          _challenges[index].currentDay,
                                      fallbackLength: 175,
                                      selectedColor:
                                          Theme.of(context).accentColor,
                                      unselectedColor:
                                          Theme.of(context).disabledColor)
                                ]),
                          ])),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
