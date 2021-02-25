import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Screens/Authenticate/SelectCompany.dart';
import 'package:personal_trainer/Screens/Authenticate/SignIn.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
// bool showSignIn = true;

// void toggleView (){
//   setState(() => showSignIn = !showSignIn);
// }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('Images/Authenticate Pic.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                  Colors.grey[800], BlendMode.hardLight)),
                ),
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Logo
          Container(
            height: 150,
            child: Image(
              image: AssetImage('Images/Brand/White Logo.png'),
              fit: BoxFit.fitHeight,
            ),
          ),
          Spacer(),
          //LogIn
          Container(
            height: 35.0,
            width: double.infinity,
            child: RaisedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => SignIn()));
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              padding: EdgeInsets.all(0.0),
              child: Ink(
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  border: Border.all(
                      color: Theme.of(context).accentColor, width: 0.8),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Container(
                  constraints: BoxConstraints(minHeight: 50.0),
                  alignment: Alignment.center,
                  child: Text(
                    "INGRESAR",
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
          //Register
          Container(
            height: 35.0,
            width: double.infinity,
            child: RaisedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => SelectCompany()));
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              padding: EdgeInsets.all(0.0),
              child: Ink(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: Theme.of(context).accentColor, width: 0.8),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Container(
                  constraints: BoxConstraints(minHeight: 50.0),
                  alignment: Alignment.center,
                  child: Text(
                    "REGISTRARME",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).accentColor),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    )));

    // if (showSignIn){
    //   return SignIn(toggleView: toggleView);
    // } else {
    //   return Register(toggleView: toggleView);
    // }
  }
}
