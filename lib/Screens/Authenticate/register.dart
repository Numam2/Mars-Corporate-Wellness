import "package:flutter/material.dart";
import 'package:personal_trainer/Firebase_Services/auth.dart';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  setSearchParam(String caseNumber) {
    List<String> caseSearchList = List();
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //Text field state
  String name = "";
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,

        ///App bar
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          title: Text("", textAlign: TextAlign.center),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 25),
              ////// First Text
              Container(
                padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 0.0),
                child: Text("Crear cuenta",
                    style: GoogleFonts.montserrat(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),

              ////// Register form
              Container(
                padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ///Name input
                      SizedBox(height: 25),
                      TextFormField(
                        style: TextStyle(color: Colors.black, fontSize: 14),
                        validator: (val) =>
                            val.isEmpty ? "No olvides gregar un nombre" : null,
                        cursorColor: Theme.of(context).accentColor,
                        decoration: InputDecoration(
                            errorStyle: GoogleFonts.montserrat(
                                color: Colors.redAccent[700], fontSize: 12),
                            hintText: "nombre",
                            hintStyle: GoogleFonts.montserrat(
                                color: Theme.of(context).canvasColor),
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: Theme.of(context).accentColor,
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor))),
                        onChanged: (val) {
                          setState(() => name = val);
                        },
                      ),

                      ///Email input
                      SizedBox(height: 25),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: Colors.black, fontSize: 14),
                        validator: (val) =>
                            val.isEmpty ? "Agrega un email" : null,
                        cursorColor: Theme.of(context).accentColor,
                        decoration: InputDecoration(
                            errorStyle: GoogleFonts.montserrat(
                                color: Colors.redAccent[700], fontSize: 12),
                            hintText: "email",
                            hintStyle: GoogleFonts.montserrat(
                                color: Theme.of(context).canvasColor),
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: Theme.of(context).accentColor,
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor))),
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),

                      ///Password input
                      SizedBox(height: 25),
                      TextFormField(
                        style: TextStyle(color: Colors.black, fontSize: 14),
                        validator: (val) => val.length < 6
                            ? "Tu contraseña debe tener al menos 6 caracteres"
                            : null,
                        cursorColor: Theme.of(context).accentColor,
                        decoration: InputDecoration(
                            errorStyle: GoogleFonts.montserrat(
                                color: Colors.redAccent[700], fontSize: 12),
                            hintText: "contraseña",
                            hintStyle: GoogleFonts.montserrat(
                                color: Theme.of(context).canvasColor),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Theme.of(context).accentColor,
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor))),
                        obscureText: true,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),

                      ///Button Register
                      SizedBox(height: 60),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 35.0,
                          child: RaisedButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                dynamic result =
                                    await _auth.registerWithEmailAndPassword(
                                        email,
                                        password,
                                        name,
                                        setSearchParam(name.toLowerCase()));

                                if (this.mounted && result == null) {
                                  setState(() => error =
                                      "This user is either taken or the combination of email and password is invalid");
                                }
                              }
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
                                  "REGISTRARME",
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
                      ),

                      //Show error if threr is an error signing in
                      SizedBox(height: 10.0),
                      Text(
                        error,
                        style: GoogleFonts.montserrat(
                            color: Colors.redAccent[700], fontSize: 14.0),
                        textAlign: TextAlign.center,
                      ),

                      /// Switch to Sign In page
                      Column(
                        children: <Widget>[
                          FlatButton(
                              onPressed: () {
                                widget.toggleView();
                              },
                              child: Text("¿Ya tienes cuenta? Entra",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.black))),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
