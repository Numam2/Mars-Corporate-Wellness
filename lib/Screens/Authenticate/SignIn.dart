import 'package:flutter/material.dart';
import 'package:personal_trainer/Firebase_Services/auth.dart';
import 'package:personal_trainer/Shared/Loading.dart';


//////////////////// //////////////////////// /////// This is were we manage the Sign in/Register Page /////////////////////////////////////

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

final AuthService _auth = AuthService();
final _formKey = GlobalKey<FormState>();
bool loading = false;

//Text field state
String email = "";
String password = "";
String error = "";

////////////////////////////////////////// Start Widget tree visible in Screen ///////////////////////////////////////////


  @override
  Widget build(BuildContext context) {
    
return loading ? Loading() : Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.blueGrey.shade900,

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
                  "Log in",
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
                      "Sign In",
                      style: TextStyle(
                        color: Colors.white),
                      ),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () async {

                      if (_formKey.currentState.validate()){
                          setState(() => loading = true);
                          dynamic result = await _auth.signInWithEmailAndPassword(email,password);
                          if (result == null){
                            setState((){
                              error = "Could not sign in with those credentials";
                              loading = false;
                            });
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
                  
                  /// Switch to Register page
                  Column(
                    children: <Widget>[
                      SizedBox(height: 30),
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
                        child: Text ("Not registered? Sign up", style: TextStyle(color: Colors.white))
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
