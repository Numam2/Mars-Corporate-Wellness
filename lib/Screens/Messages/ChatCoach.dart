import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Models/messages.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Home/HirePersonalizedRoutine.dart';

class ChatCoach extends StatelessWidget {
  final List<ChatsList> chats;
  final String user;
  final UserProfile userProfile;
  ChatCoach({this.user, this.userProfile, this.chats});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HirePersonalizedRoutine(myUserProfile: userProfile, chats: chats)));
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Theme.of(context).primaryColor,
          gradient: LinearGradient(
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //User Image
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[100],
              child: ClipOval(
                child: Container(
                    height: 60,
                    width: 60,
                    color: Colors.grey[200],
                    child: Image.network('https://firebasestorage.googleapis.com/v0/b/ludus-health-coach.appspot.com/o/Brand%20Images%2FB-W%20Logo%20in%20Column.png?alt=media&token=e8a7517b-53c0-4877-ae92-765bcce43d42', 
                    fit: BoxFit.cover)
                ),
              ),
            ),
            SizedBox(width: 15),

            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'MARS Personal Coach',
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Chatea con tu coach personal',
                    style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.white),
                  ),
                ]),
          ],
        ),
      ),
    );
  }
}
