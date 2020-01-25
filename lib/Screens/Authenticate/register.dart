import "package:flutter/material.dart";
import 'package:personal_trainer/Firebase_Services/auth.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

final AuthService _auth = AuthService();
final _formKey = GlobalKey<FormState>();

//Text field state
String email = "";
String password = "";
String error = "";

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.blueGrey.shade900,

      ///App bar
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade900,
        elevation: 0.0,
        title: Text("",textAlign: TextAlign.center
          ),
        ),
 
      body: Stack(children: <Widget>[

        ////// First Text 
        Container(
          padding: EdgeInsets.fromLTRB(25.0, 110.0, 0.0, 0.0),
          child: Text(
                  "Sing Up",
                  style: TextStyle(
                    fontSize: 40.0, fontFamily: "Roboto", fontWeight: FontWeight.bold, color: Colors.white
                  )
          ),
        ),
        
        ////// Register form
        Container(
          padding: EdgeInsets.fromLTRB(25.0, 175.0, 25.0, 0.0),
          child:Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                  ///Email input
                  SizedBox(height: 25),
                  TextFormField(
                    validator: (val) => val.isEmpty ? "Enter an email" : null,
                    decoration: InputDecoration(
                      hintText: "email",
                      hintStyle: TextStyle(color: Colors.grey.shade700),
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: Colors.grey,
                      ),
                      focusedBorder: UnderlineInputBorder(  
                        borderSide: BorderSide(color: Colors.lightBlueAccent)
                      )
                    ),
                    onChanged: (val){
                      setState(() => email = val);
                    },
                  ),

                  ///Password input
                  SizedBox(height: 25),
                  TextFormField(
                    validator: (val) => val.length < 6 ? "Your password must have at least 6 characters" : null,
                    decoration: InputDecoration(
                      hintText: "password",
                      hintStyle: TextStyle(color: Colors.grey.shade700),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.grey,
                      ),
                      focusedBorder: UnderlineInputBorder(  
                        borderSide: BorderSide(color: Colors.lightBlueAccent)
                      )
                    ),
                    obscureText: true,
                    onChanged: (val){
                      setState(() => password = val);
                    },
                  ),
                  
                  ///Button Register
                  SizedBox(height: 50),
                  RaisedButton(
                    color: Colors.black,
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.white),
                      ),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()){
                        dynamic result = await _auth.registerWithEmailAndPassword(email,password);
                          
                         if (this.mounted && result == null) {
                          setState(() => error = "Please provide a valid combination of email and password");
                         }
                      }
                    }
                  ),

                  //Show error if threr is an error signing in
                  SizedBox(height: 10.0),
                  Text(
                    error,
                    style: 
                    TextStyle(color: Colors.red, fontSize: 14.0),
                    textAlign: TextAlign.center,
                  ),

                  /// Switch to Sign In page
                  Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      Text(
                        "- OR -",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey)
                      ),
                      
                      SizedBox(height: 10),
                      FlatButton(
                        onPressed: () {
                          widget.toggleView();
                        },
                        child: Text ("Already registered? Sign in", style: TextStyle(color: Colors.white))
                        ),
                        ],
                    )
              ],

              ),
          ),

        ),

      ],
      )
    );

  }
}