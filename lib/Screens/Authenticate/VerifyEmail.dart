import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Screens/Authenticate/authenticate.dart';
import 'package:personal_trainer/Screens/Home/Inicio_Navigate.dart';

class VerifyEmail extends StatefulWidget {
  final String email;
  VerifyEmail({this.email});

  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final auth = FirebaseAuth.instance;
  User user;
  Timer timer;

  @override
  void initState() {
    user = auth.currentUser;
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Back
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Authenticate()));
                        },
                        child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white38,
                            ),
                            child: Icon(Icons.keyboard_arrow_left,
                                color: Colors.black)),
                      ),
                    ]),
                    //Image
                    Container(
                        height: MediaQuery.of(context).size.width * 0.6,
                        child: Image(
                            image: AssetImage('Images/Email Confirmation.jpg'),
                            height: 70)),
                    SizedBox(height: 30),
                    //Title
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75),
                      child: Text(
                        "Confirma tu email",
                        style: GoogleFonts.montserrat(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 15),
                    //Text
                    (widget.email == null)
                        ? Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.75),
                            child: Text(
                              "Enviamos un correo de confirmación a tu email",
                              style: Theme.of(context).textTheme.bodyText2,
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.75),
                            child: Text(
                              "Enviamos un correo de confirmación a",
                              style: Theme.of(context).textTheme.bodyText2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                    SizedBox(height: 10),
                    //Email
                    (widget.email == null)
                        ? SizedBox()
                        : Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.75),
                            child: Text(
                              "${widget.email}",
                              style: Theme.of(context).textTheme.headline4,
                              textAlign: TextAlign.center,
                            ),
                          ),
                    SizedBox(height: 10),
                    //Text
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75),
                      child: Text(
                        "Verifica tu inbox y haz click en el link del mail para activar tu cuenta",
                        style: Theme.of(context).textTheme.bodyText2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 10),
                    //Resend email
                    TextButton(
                        onPressed: () {
                          user = auth.currentUser;
                          user.sendEmailVerification();
                        },
                        child: Text("Reenviar correo",
                            style:
                                GoogleFonts.montserrat(color: Theme.of(context).accentColor))),
                  ],
                ))));
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user.reload();

    if (user.emailVerified) {
      timer.cancel();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => InicioNew()));
    }
  }
}
