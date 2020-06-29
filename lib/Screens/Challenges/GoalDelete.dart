import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';

class GoalDelete extends StatelessWidget {
  final String goalDescription;
  GoalDelete({this.goalDescription});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
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
                  "¿Borrar esta meta?",
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
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    
                    Container(
                      height: 35.0,
                      width: 100,
                      child: RaisedButton(
                        onPressed: () async {
                          DatabaseService().deleteGoal(goalDescription);
                          Timer(Duration(seconds: 1), () {});
                          Navigator.pop(context);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            border: Border.all(color: Theme.of(context).accentColor, width: 0.8),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 200.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              "SI",
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
                    SizedBox(width: 20),
                    Container(
                      height: 35.0,
                      width: 100,
                      child: RaisedButton(
                        onPressed: () => Navigator.pop(context),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            border: Border.all(color: Theme.of(context).accentColor, width: 0.8),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 200.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              "NO",
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
                    
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
