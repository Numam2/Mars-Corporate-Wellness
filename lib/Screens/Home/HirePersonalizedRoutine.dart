import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/messages.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Messages/ChatRoomCoach.dart';
import 'package:provider/provider.dart';

class HirePersonalizedRoutine extends StatelessWidget {

  final UserProfile myUserProfile;
  final List<ChatsList> chats;
  HirePersonalizedRoutine({this.myUserProfile, this.chats});
  
  @override
  Widget build(BuildContext context) {

    // final _user = Provider.of<UserProfile>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.keyboard_arrow_left,
            color: Colors.black,
          ),
        ),
      ),
      body: Stack(children: <Widget>[
        ///The page
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /// Logo
                  Container(
                    height: 75,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage('Images/Brand/Blue Isologo.png'))),
                  ),

                  ///Greetings Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:<Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Container(
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.80),
                          child: Text(
                            "Mars Fitness Coach",
                            style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 30),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ] 
                  ),

                  ///Greetings Text
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 5),
                    child: Text(
                      "Personaliza tu experiencia y alcanza un óptimo bienestar físico con la guía de tu fitness coach personal",
                      style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 20),

                  //List of benefits
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Column(children: <Widget>[
                        //1
                        Row(
                          children: <Widget>[
                            Icon(Icons.check,
                                size: 20, color: Theme.of(context).accentColor),
                            SizedBox(width: 20),
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7),
                              child: Text(
                                'Personaliza tu plan de entrenamiento para adaptarse a tu tiempo, preferencias y objetivos',
                                style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 15),

                        //2
                        Row(
                          children: <Widget>[
                            Icon(Icons.check,
                                size: 20, color: Theme.of(context).accentColor),
                            SizedBox(width: 20),
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7),
                              child: Text(
                                'Orientación y apoyo en establecer hábitos y metas que lideren a un futuro mucho más saludable',
                                style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 15),

                        //3
                        Row(
                          children: <Widget>[
                            Icon(Icons.check,
                                size: 20, color: Theme.of(context).accentColor),
                            SizedBox(width: 20),
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7),
                              child: Text(
                                'Integración ideal de planes de entrenamiento y hábitos nutricionales',
                                style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 15),

                        //4
                        Row(
                          children: <Widget>[
                            Icon(Icons.check,
                                size: 20, color: Theme.of(context).accentColor),
                            SizedBox(width: 20),
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7),
                              child: Text(
                                'Gestiona el entrenamiento ante la presencia de lesiones y ayuda a prevenir lesiones futuras',
                                style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 15),

                        //5
                        Row(
                          children: <Widget>[
                            Icon(Icons.check,
                                size: 20, color: Theme.of(context).accentColor),
                            SizedBox(width: 20),
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7),
                              child: Text(
                                'Constante disponibilidad a través del chat de la app',
                                style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                            )
                          ],
                        ),
                      ])),
                  SizedBox(height: 120),
                ]),
          ),
        ),

        /// Button
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 35.0,
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: RaisedButton(
                      onPressed: () {
                        ///// Create a certain Doc ID
                        final String generateDocID = myUserProfile.uid + 'eLCgS7xXVWMwvY5BQ0h86yryFZz2';

                        ///// Create Chat Room based on that Doc ID
                        DatabaseService()
                            .createFirstChat('eLCgS7xXVWMwvY5BQ0h86yryFZz2', generateDocID);

                        //// Set has personal coach to true
                        DatabaseService()
                            .havePersonalizedCoach(true);

                        ///// Navigate to that chat room
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MultiProvider(
                                  providers: [
                                    StreamProvider<ChatsList>.value(value: DatabaseService().selectedChat(generateDocID)),
                                  ],
                                  child: ChatRoomCoach(
                                    myUserProfile: myUserProfile,
                                    docID: generateDocID, 
                                    profilePic: 'https://firebasestorage.googleapis.com/v0/b/ludus-health-coach.appspot.com/o/Brand%20Images%2FB-W%20Logo%20in%20Column.png?alt=media&token=e8a7517b-53c0-4877-ae92-765bcce43d42', 
                                    name: 'Mars Coach'),
                                )));
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
                          alignment: Alignment.center,
                          child: Text(
                            "CHATEA CON TU COACH",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ]),
    );
  }
}
