import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:personal_trainer/Firebase_Services/auth.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Screens/Profile/Onboarding.dart';

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
String name = "";
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
 
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

        ////// First Text 
        Container(
          padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 0.0),
          child: Text(
                  "Sing Up",
                  style: TextStyle(
                    fontSize: 40.0, fontFamily: "Roboto", fontWeight: FontWeight.bold, color: Colors.white
                  )
          ),
        ),
        
        ////// Register form
        Container(
          padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0.0),
          child:Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                  ///Name input
                  SizedBox(height: 25),
                  TextFormField( 
                    style: TextStyle(color:Colors.white),                   
                    validator: (val) => val.isEmpty ? "Please enter a name" : null,
                    cursorColor: Colors.redAccent[700],
                    decoration: InputDecoration(                      
                      hintText: "name",
                      hintStyle: TextStyle(color: Colors.grey.shade700),
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: Colors.grey,
                      ),
                      focusedBorder: UnderlineInputBorder(  
                        borderSide: BorderSide(color: Colors.redAccent[700])
                      )
                    ),
                    onChanged: (val){
                      setState(() => name = val);
                    },
                  ),

                  ///Email input
                  SizedBox(height: 25),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color:Colors.white),                   
                    validator: (val) => val.isEmpty ? "Enter an email" : null,
                    cursorColor: Colors.redAccent[700],
                    decoration: InputDecoration(                      
                      hintText: "email",
                      hintStyle: TextStyle(color: Colors.grey.shade700),
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: Colors.grey,
                      ),
                      focusedBorder: UnderlineInputBorder(  
                        borderSide: BorderSide(color: Colors.redAccent[700])
                      )
                    ),
                    onChanged: (val){
                      setState(() => email = val);
                    },
                  ),

                  ///Password input
                  SizedBox(height: 25),
                  TextFormField(
                    style: TextStyle(color:Colors.white), 
                    validator: (val) => val.length < 6 ? "Your password must have at least 6 characters" : null,
                    cursorColor: Colors.redAccent[700],
                    decoration: InputDecoration(
                      hintText: "password",
                      hintStyle: TextStyle(color: Colors.grey.shade700),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.grey,
                      ),
                      focusedBorder: UnderlineInputBorder(  
                        borderSide: BorderSide(color: Colors.redAccent[700])
                      )
                    ),
                    obscureText: true,
                    onChanged: (val){
                      setState(() => password = val);
                    },
                  ),
                  
                  ///Button Register
                  SizedBox(height: 60),
                  Container(
                    padding: EdgeInsets.only(left:40,right:40),                    
                    height: 40,
                    child: RaisedButton(
                      color: Colors.redAccent[700],
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Onboarding()));
                          dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                          final FirebaseUser user = await FirebaseAuth.instance.currentUser();
                          final String uid = user.uid.toString();
                          await DatabaseService(uid: uid).updateUserData(name,'Sex', '00', '0.0', '0.0', 'None', 'None', 'None',0,0,0);                                            
                           if (this.mounted && result == null) {
                            setState(() => error = "Please provide a valid combination of email and password");
                           }                          
                        }
                      }
                    ),
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