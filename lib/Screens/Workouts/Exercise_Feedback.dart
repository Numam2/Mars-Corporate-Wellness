import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Shared/Loading.dart';

class ExerciseFeedback extends StatefulWidget {
  final String exercise;
  ExerciseFeedback({Key key, this.exercise}) : super(key: key);

  @override
  _ExerciseFeedbackState createState() => _ExerciseFeedbackState();
}

class _ExerciseFeedbackState extends State<ExerciseFeedback> {
  Future updateUserData(String reaction, String notes) async {
    var firestore = Firestore.instance;
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return await firestore
        .collection('User Profile')
        .document(uid)
        .collection('Feedback')
        .document(widget.exercise)
        .setData({
      'Reaction': reaction,
      'Notes': notes,
    });
  }

  String _notes = '';

  List emojiList = [
    'Images/Emoji/Sunglasses.png',
    'Images/Emoji/Hurt.png',
    'Images/Emoji/Dead.png'
  ];
  Color _emojiColor = Colors.grey[300];
  Color _emojiColor1 = Colors.grey[300];
  Color _emojiColor2 = Colors.grey[300];
  String _emojiReaction = '';
  bool loading = false;

  void _sendFeedback() async {
    setState(() {
      loading = true;
    });
    await updateUserData(_emojiReaction, _notes);

    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });

    
  }



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Container(
          height: 400,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
            child: Stack(
              children:<Widget>[
                //Loading
                Center(
                  child: loading ? Loading() : SizedBox()
                ),
                //Content
                Opacity(
                  opacity: loading ? 0.3 : 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment(1.0, 0.0),
                        child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.close),
                            iconSize: 20.0),
                      ),                      
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "¿Cómo te fue con " + widget.exercise + "?",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _emojiReaction = 'Cool';
                                  _emojiColor = Theme.of(context).accentColor;
                                  _emojiColor1 = Colors.grey[300];
                                  _emojiColor2 = Colors.grey[300];
                                });
                              },
                              child: Container(
                                height: 75,
                                width: 75,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color:_emojiColor, width: 1.5),
                                ),
                                child: Center(
                                  child: Container(
                                    height:30,
                                    child: Image(
                                      image: AssetImage('Images/Emoji/Sunglasses.png')
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _emojiReaction = 'Hurt';
                                  _emojiColor = Colors.grey[300];
                                  _emojiColor1 = Theme.of(context).accentColor;
                                  _emojiColor2 = Colors.grey[300];
                                });
                              },
                              child: Container(
                                height: 75,
                                width: 75,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color:_emojiColor1, width: 1.5),
                                ),
                                child: Center(
                                  child: Container(
                                    height:30,
                                    child: Image(
                                      image: AssetImage('Images/Emoji/Hurt.png')
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _emojiReaction = 'Dead';
                                  _emojiColor = Colors.grey[300];
                                  _emojiColor1 = Colors.grey[300];
                                  _emojiColor2 = Theme.of(context).accentColor;
                                });
                              },
                              child: Container(
                                height: 75,
                                width: 75,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color:_emojiColor2, width: 1.5),
                                ),
                                child: Center(
                                  child: Container(
                                    height:30,
                                    child: Image(
                                      image: AssetImage('Images/Emoji/Dead.png')
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(color: Colors.grey, width: 0.8),
                        ),
                        child: TextField(
                          style: GoogleFonts.montserrat(fontSize: 14),
                          cursorColor: Theme.of(context).accentColor,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Deja un comentario (ej. cambié las repeticiones)'),
                          onChanged: (val) {
                            setState(() => _notes = val);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Container(
                        height: 35.0,
                        child: RaisedButton(
                          onPressed: _sendFeedback,
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
                              constraints:
                                  BoxConstraints(maxWidth: 200.0, minHeight: 50.0),
                              alignment: Alignment.center,
                              child: Text(
                                "GUARDAR",
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
                      //SizedBox(height: 25),
                    ],
                  ),
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}
