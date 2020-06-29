import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/groups.dart';
import 'package:personal_trainer/Models/messages.dart';
import 'package:personal_trainer/Shared/ShareChat.dart';
import 'package:personal_trainer/Shared/ShareGroup.dart';
import 'package:provider/provider.dart';

class SharePrompt extends StatelessWidget {
  final String type;
  final String headline;
  final String time;
  final IconData activityIcon;
  SharePrompt({this.type, this.headline, this.time, this.activityIcon});

  @override
  Widget build(BuildContext context) {

    print(
      time +
      headline +
      type    
    );

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Container(
        height: 250,
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
                  "Comparte",
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    
                    Container(
                      height: 35.0,
                      width: 300,
                      child: RaisedButton(
                        onPressed: () {
                          return showDialog(
                          context: context,
                            builder: (context) {
                              return StreamProvider<List<ChatsList>>.value(
                                value: DatabaseService().chatsList,
                                child: ShareChat(
                                  type: type,
                                  headline: headline,
                                  time: time,
                                  activityIcon: activityIcon,
                                ),
                              );
                            });
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
                            alignment: Alignment.center,
                            child: Text(
                              "CHAT",
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
                    SizedBox(height: 10),
                    Container(
                      height: 35.0,
                      width: 300,
                      child: RaisedButton(
                        onPressed: () {
                          return showDialog(
                          context: context,
                            builder: (context) {
                              return StreamProvider<List<Groups>>.value(
                                value: DatabaseService().myGroupList,
                                child: ShareGroup(
                                  type: type,
                                  headline: headline,
                                  time: time,
                                  activityIcon: activityIcon,
                                ),
                              );
                            });
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
                            alignment: Alignment.center,
                            child: Text(
                              "GRUPO",
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
