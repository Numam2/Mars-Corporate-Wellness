import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:personal_trainer/Firebase_Services/auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Screens/Authenticate/SignIn.dart';
import 'package:personal_trainer/Screens/Profile/Onboarding.dart';
import 'package:personal_trainer/Screens/wrapper.dart';
import 'package:personal_trainer/Shared/Loading.dart';

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

  final FocusNode _nameNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode _rePasswordNode = FocusNode();

  //Text field state
  String name = "";
  String email = "";
  String password = "";
  String rePassword = "";
  String error = "";

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
    ? SafeArea(
          child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Loading()),
    )
    : SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,

          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 35),
                
                ////// Logo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:<Widget>[
                        Container(
                          height: 70,
                          child: Image(image: AssetImage('Images/Brand/Blue Isologo.png'), height: 70)),
                      ] 
                    ),
                    SizedBox(height:15),
                
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
                          focusNode: _nameNode,
                          textInputAction: TextInputAction.next,
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
                          onFieldSubmitted: (term){
                            _nameNode.unfocus();
                            FocusScope.of(context).requestFocus(_emailNode);
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
                          focusNode: _emailNode,
                          textInputAction: TextInputAction.next,
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
                          onFieldSubmitted: (term){
                            _emailNode.unfocus();
                            FocusScope.of(context).requestFocus(_passwordNode);
                          },
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
                          focusNode: _passwordNode,
                          textInputAction: TextInputAction.next,
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
                          onFieldSubmitted: (term){
                            _passwordNode.unfocus();
                            FocusScope.of(context).requestFocus(_rePasswordNode);
                          },
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                        ),

                        //Reenter Password
                        SizedBox(height: 25),
                        TextFormField(
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          validator: (val) => val.length < 6
                              ? "Tu contraseña debe tener al menos 6 caracteres"
                              : null,
                          cursorColor: Theme.of(context).accentColor,
                          focusNode: _rePasswordNode,
                          decoration: InputDecoration(
                              errorStyle: GoogleFonts.montserrat(
                                  color: Colors.redAccent[700], fontSize: 12),
                              hintText: "Reingresa la contraseña",
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
                            setState(() => rePassword = val);
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
                                if (_formKey.currentState.validate() && rePassword == password) {

                                  setState(() => loading = true);

                                  try {

                                    User user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                      email: email,
                                      password: password)).user;

                                      await DatabaseService(uid: user.uid).createUserRoutine('Day 1');
                                      await DatabaseService(uid: user.uid).createUserProfile(name, setSearchParam(name.toLowerCase()));

                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Wrapper()));
                                                
                                      } on FirebaseAuthException catch (e) {
                                          if (e.code == 'email-already-in-use') {
                                            setState(() {
                                              error = 'El usuario $email ya está en uso';
                                              loading = false;
                                            });                                          
                                          } else if (e.code == 'invalid-email') {
                                            setState(() {
                                              error = 'El email es inválido';
                                              loading = false;
                                            });                                             
                                          } else {
                                            setState(() {
                                              error = 'Oops.. Algo salió mal';
                                              loading = false;
                                            });                                          
                                          }                               
                                      } catch(e){
                                        setState(() {
                                              error = 'Oops.. Algo salió mal';
                                              loading = false;
                                          });
                                        // return null;
                                      }

                              } else if (rePassword != password){
                                    setState((){ 
                                      error = "Oops.. las contraseñas no coinciden, vuelve a intentarlo";
                                      loading = false;                                                                  
                                    });
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
                        (error == '')
                        ? SizedBox(height: 0.0)
                        : SizedBox(height: 10.0),
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
                                  //widget.toggleView();
                                  Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => SignIn()));
                                },
                                child: Text("¿Ya tienes cuenta? Entra",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.black))),
                          ],
                        ),
                        SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
