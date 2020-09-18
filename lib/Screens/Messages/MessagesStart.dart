import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/messages.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Messages/MessageHome.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:provider/provider.dart';

class MessagesStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _profile = Provider.of<UserProfile>(context);

    if (_profile == null){
      return Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Loading(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
        ),
        centerTitle: true,
        title: Text('Coach',
            style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: Colors.black)),
      ),
      body: Container(
        color: Colors.white,
        height: double.infinity,
        width: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              /// Message Icon
              Icon(Icons.chat, color: Theme.of(context).primaryColor, size: 40),

              ///Greetings Text
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 5),
                child: Text(
                  "Hey " + _profile.name + "!",
                  style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                  textAlign: TextAlign.center,
                ),
              ),

              ///Greetings Text
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 15, 30, 5),
                child: Text(
                  "Aca puedes chatear con tu coach para que te guíe en tu camino. Te puede crear rutinas de entrenamiento personalizadas y alinear tus hábitos y metas",
                  style: Theme.of(context).textTheme.body1,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 15),

              /// Button
              Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ///Chat with Mars Coach
                      Container(
                        height: 35.0,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MultiProvider(
                                            providers:[
                                              StreamProvider<List<ChatsList>>.value(value: DatabaseService().chatsList),
                                              StreamProvider<UserProfile>.value(value: DatabaseService().userData)
                                            ],
                                            child: MessagesHome())));
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
                                "COMIENZA",
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

                      // Container(
                      //   width: 150,
                      //   child: RaisedButton(
                      //     color: Theme.of(context).primaryColor,
                      //     child: Text(
                      //       "COMIENZA",
                      //       style: Theme.of(context).textTheme.button),
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(20),
                      //       ),
                      //       onPressed: () {
                      //         Navigator.push(
                      //           context, MaterialPageRoute(builder: (context) =>
                      //             StreamProvider<List<ChatsList>>.value(
                      //               value: DatabaseService().chatsList,
                      //               child: MessagesHome())));
                      //       }
                      //   ),
                      // ),
                    ],
                  )),
            ]),
      ),
    );
  }
}
