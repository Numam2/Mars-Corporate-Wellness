import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Screens/Profile/Onboarding.dart';

class MissingProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'Por favor, completa tu información para poder acceder a tu perfil',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.black),
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.only(left: 40, right: 40),
            height: 40,
            child: RaisedButton(
                color: Theme.of(context).buttonColor,
                child: Text(
                  "COMIENZA",
                  style: GoogleFonts.montserrat(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Onboarding()));
                }),
          ),
        ],
      ),
    );
  }
}
