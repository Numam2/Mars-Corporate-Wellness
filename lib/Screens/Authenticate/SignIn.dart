import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/auth.dart';
import 'package:personal_trainer/Screens/Authenticate/SelectCompany.dart';
import 'package:personal_trainer/Screens/Authenticate/register.dart';
import 'package:personal_trainer/Screens/Home/Inicio_Navigate.dart';
import 'package:personal_trainer/Screens/wrapper.dart';
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

  final FocusNode _emailNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();

//Text field state
  String email = "";
  String password = "";
  String error = "";

  goHome() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => InicioNew()));
  }

////////////////////////////////////////// Start Widget tree visible in Screen ///////////////////////////////////////////

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
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0.0,
                automaticallyImplyLeading: false,
                title: Text("", textAlign: TextAlign.center),
              ),
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
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
                      child: Text("Ingresar",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.montserrat(
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ),

                    ////// Register form
                    Container(
                      padding: EdgeInsets.fromLTRB(25.0, 25, 25.0, 0.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
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
                                  hintText: "email",
                                  hintStyle: GoogleFonts.montserrat(
                                      color: Theme.of(context).canvasColor),
                                  errorStyle: GoogleFonts.montserrat(
                                    color: Colors.redAccent[700], fontSize: 12),
                                  prefixIcon: Icon(
                                    Icons.person_outline,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).accentColor))
                              ),
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
                                  ? "La contraseña debe tener al menos 6 caracteres"
                                  : null,
                              cursorColor: Theme.of(context).accentColor,
                              focusNode: _passwordNode,
                              decoration: InputDecoration(
                                  hintText: "contraseña",
                                  hintStyle: GoogleFonts.montserrat(
                                      color: Theme.of(context).canvasColor),
                                  errorStyle: GoogleFonts.montserrat(
                                    color: Colors.redAccent[700], fontSize: 12),
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
                                      //Loading
                                      setState(() => loading = true);
                                                                   
                                      try {
                                        await FirebaseAuth.instance
                                            .signInWithEmailAndPassword(
                                                email: email,
                                                password: password);
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => Wrapper()));
                                                

                                      } on FirebaseAuthException catch (e) {
                                          if (e.code == 'user-not-found') {
                                            setState(() {
                                              error = 'No encontramos el usuario $email. Revisa de nuevo';
                                              loading = false;
                                            });                                          
                                          } else if (e.code == 'wrong-password') {
                                            setState(() {
                                              error = 'Contraseña incorrecta, intenta de nuevo';
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
                                        "ENTRAR",
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
                            SizedBox(height: 5.0),
                            Text(
                              error,
                              style: GoogleFonts.montserrat(
                                  color: Colors.redAccent[700], fontSize: 12.0),
                              textAlign: TextAlign.center,
                            ),

                            /// Switch to Register page
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => SelectCompany()));
                                      //widget.toggleView();
                                    },
                                    child: Text("¿No tienes cuenta? Regístrate",
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
              )),
        );
  }
}
