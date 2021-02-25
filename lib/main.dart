import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Home/Inicio_Navigate.dart';
import 'package:personal_trainer/Screens/SplashScreen.dart';
import 'package:personal_trainer/Screens/wrapper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  final bool signedOut;
  MyApp({this.signedOut});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  @override
  Widget build(BuildContext context) {

    // Colors
    // Dark Blue Color(0xff0033A1)
    // Green Accen Color(0xff00CE7C)

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.white,
    //   statusBarBrightness: Brightness.dark,
    //   statusBarIconBrightness: Brightness.dark
    // ));

    HttpOverrides.global = new MyHttpOverrides();


    return MultiProvider(
      providers:[
        ///User Provider
        StreamProvider<UserProfile>.value(value: DatabaseService().userData),
        StreamProvider<User>.value(value: FirebaseAuth.instance.userChanges()),
        StreamProvider<ProgressPictureList>.value(value: DatabaseService().progressPictures),                                        
        ///Group Notifications Provider
        StreamProvider<GroupNotificationList>.value(value: DatabaseService().groupNotifications),
      ],
      
      child: MaterialApp(
        theme: ThemeData(          
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Color(0xff0033A1), ////Drak Blue
          accentColor: Color(0xff00CE7C), //// Green
          canvasColor: Color(0xff706F6F), //// Grey (Dark)
          disabledColor: Color(0xffDADADA), //// Grey (Light)
          buttonColor: Color(0xff0033A1),
          textTheme: TextTheme(
            headline5: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black),
            caption: GoogleFonts.montserrat(
              fontSize: 25.0,
              fontWeight: FontWeight.w500,
              color: Colors.white),
            headline6: GoogleFonts.montserrat(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: Colors.black),
            subtitle2: GoogleFonts.montserrat(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Colors.black),
            headline4: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black),
            headline3: GoogleFonts.montserrat(
              fontSize: 10,
              fontWeight: FontWeight.w200,
              color: Colors.black),
            bodyText2:GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.black),
            subtitle1: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.black),
            bodyText1: GoogleFonts.montserrat(
              fontSize: 12,
              fontStyle: FontStyle.italic, 
              fontWeight: FontWeight.w400,
              color: Colors.black),
            button: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white),
            headline2: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xff0033A1)),
          )
        ),
        routes: <String, WidgetBuilder> {
          '/Home': (BuildContext context) => InicioNew(),
        },
        debugShowCheckedModeBanner: false,
        home: (widget.signedOut == null) 
        ? SplashScreen()
        : Wrapper()
      
      ),
    );
  }
}


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

















//Couse Flutter Code

//import './questions.dart';
//import './answers.dart';

//void main() {
  //runApp(MyApp());
//}

//class MyApp extends StatefulWidget {

  //@override
  //_MyAppState createState() => _MyAppState();
//}



//class _MyAppState extends State<MyApp> {
  //var numberofquestion = 0;

//void answerQ(){
  // setState((){
    //numberofquestion = numberofquestion + 1;
   //});
//}
 
  //@override
  //Widget build(BuildContext context) {

    //var questions = [
     // {"Texto" : "Cual es tu ejercicio favorito?", "Respuestass" : ["Squats","Cleans","Jerks","Swings"]},
      //{"Texto" : "Cual es tu dia favorito?", "Respuestass" : ["Lunes","Martes","Sabado"]},
      //{"Texto" : "Cual es tu musica preferida?", "Respuestass" : ["Rock","Pock","Hic Hok","Jass","Tango"]},
    //];

    //return MaterialApp(
      //home: Scaffold(
          //appBar: AppBar(
            //title: Text("Ludus Coach"),
          //),
          //body: Column(
            //children: [
              //Preguntas(questions[numberofquestion]["Texto"]),

              //...(questions[numberofquestion]["Respuestass"] as List<String>).map((answer){
                //return Respuestas(answerQ,answer);
              //}).toList()
            //],
          //)),
    //);
  //}
//}