import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ExerciseFeedback extends StatefulWidget {

  final String exercise;
  ExerciseFeedback ({Key key, this.exercise}) : super(key:key);

  @override
  _ExerciseFeedbackState createState() => _ExerciseFeedbackState();
}

class _ExerciseFeedbackState extends State<ExerciseFeedback> {


    Future updateUserData (String reaction, String notes) async {
      var firestore = Firestore.instance;
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      final String uid = user.uid.toString();
      return await firestore.collection('User Profile').document(uid).collection('Feedback').document(widget.exercise).setData({
        'Reaction': reaction,
        'Notes': notes,
      });
  }
  
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  Color _buttonColor = Colors.black;
  String _notes = '';

  List emojiList = [
    'Images/Emoji/Sunglasses.png',
    'Images/Emoji/Hurt.png',
    'Images/Emoji/Dead.png'
  ];
  Color _emojiColor = Color.fromRGBO(0, 0, 0, 0);
  Color _emojiColor1 = Color.fromRGBO(0, 0, 0, 0);
  Color _emojiColor2 = Color.fromRGBO(0, 0, 0, 0);
  String _emojiReaction = '';

  void _sendFeedback() async {
    Timer(Duration(seconds: 2), () {
      _btnController.success();
      print(_emojiReaction);
      print(_notes);      
      setState(() {
        _buttonColor = Colors.green;
      });
    });
    await updateUserData(_emojiReaction,_notes);
    
    Timer(Duration(seconds: 2), () {Navigator.of(context).pop();});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Container(
          height: 400,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
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

                SizedBox(
                  height: 10,
                ),

                Text(
                  "How did it go with the " + widget.exercise +"?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.bold,
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
                    children: <Widget> [
                      
                      Material(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _emojiReaction = 'Cool';
                            _emojiColor = Colors.grey;
                            _emojiColor1 = Color.fromRGBO(0, 0, 0, 0);
                            _emojiColor2 = Color.fromRGBO(0, 0, 0, 0);
                          });
                        },
                        splashColor: Colors.black.withOpacity(0.5),
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: _emojiColor,
                              image: DecorationImage(
                                image: AssetImage('Images/Emoji/Sunglasses.png'),
                                fit: BoxFit.cover,
                              )),
                        ),
                      ),
                    ),

                    SizedBox(width: 20),
                    
                    Material(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _emojiReaction = 'Hurt';
                            _emojiColor = Color.fromRGBO(0, 0, 0, 0);
                            _emojiColor1 = Colors.grey;
                            _emojiColor2 = Color.fromRGBO(0, 0, 0, 0);
                          });
                        },
                        splashColor: Colors.black.withOpacity(0.5),
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: _emojiColor1,
                              image: DecorationImage(
                                image: AssetImage('Images/Emoji/Hurt.png'),
                                fit: BoxFit.cover,
                              )),
                        ),
                      ),
                    ),

                    SizedBox(width: 20),
                    
                    Material(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _emojiReaction = 'Dead';
                            _emojiColor = Color.fromRGBO(0, 0, 0, 0);
                            _emojiColor1 = Color.fromRGBO(0, 0, 0, 0);
                            _emojiColor2 = Colors.grey;
                          });
                        },
                        splashColor: Colors.black.withOpacity(0.5),
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: _emojiColor2,
                              image: DecorationImage(
                                image: AssetImage('Images/Emoji/Dead.png'),
                                fit: BoxFit.cover,
                              )),
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
                  padding: EdgeInsets.only(left:10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    cursorColor: Colors.redAccent[700],
                    decoration: InputDecoration(
                        border: InputBorder.none,                        
                        hintText:
                            'Leave a note (e.g. changed weight, could not do as many reps...)'),
                     onChanged: (val){
                          setState(() => _notes = val);
                        },
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                SizedBox(
                  width: 250.0,
                  child: RoundedLoadingButton(
                    color: _buttonColor,
                    child: Text('Submit', style: TextStyle(color: Colors.white)),
                    controller: _btnController,
                    onPressed: _sendFeedback,
                    width: 200,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
