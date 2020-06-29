import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:provider/provider.dart';

class ShareChatUserData extends StatefulWidget {
  final String myUID;
  final int usersinChat;
  final String chatDocID;
  final DateTime lastMessageTime;
  final DateTime lastRead;

  final String type;
  final String headline;
  final String time;
  final String text;

  ShareChatUserData({this.chatDocID, this.lastMessageTime, this.lastRead, this.myUID, this.usersinChat, this.type, this.headline, this.time, this.text});

  @override
  _ShareChatUserDataState createState() => _ShareChatUserDataState();
}

class _ShareChatUserDataState extends State<ShareChatUserData> {

  bool messageSent = false;

  @override
  Widget build(BuildContext context) {

    final _user = Provider.of<UserProfile>(context);

    if (_user == null || widget.lastRead == null){
      return SizedBox();
    }
  
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //User Image
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[100],
            child: ClipOval(
              child: Container(
                  height: 40,
                  width: 40,
                  color: Colors.grey[200],
                  child: Image.network(
                  _user.profilePic,
                  fit: BoxFit.cover)),
            ),
          ),
          SizedBox(width: 10),
          //User Name and BIO
          Container(
            width: MediaQuery.of(context).size.width*0.35,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints(maxWidth: 140),
                    child: Text(
                      _user.name,
                      style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: 3),

                  (_user.about == null || _user.about == '')
                  ?  Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.35),
                    child: Text(
                      _user.name,
                      style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey[800]),
                    ),
                  )
                  : Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.35),
                    child: Text(
                      _user.about,
                      style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey[800]),
                    ),
                  ),
                ]),
          ),
          SizedBox(width: 10),
          //Send
          messageSent
          ? Icon(Icons.check, color: Theme.of(context).accentColor, size: 18)
          : InkWell(
              onTap: () async {
                setState(() {
                  messageSent = true;
                });
                DatabaseService().updateChatDate(widget.chatDocID);     
                DatabaseService().sendSharedMessage(widget.chatDocID, widget.text, widget.type, widget.headline, widget.time);
                await DatabaseService().updateMyLastRead(widget.chatDocID);
                await DatabaseService().deletePreviousLastRead(widget.chatDocID, widget.lastRead);                           
              },
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).accentColor,
                ),
                child: Center(
                  child: Icon(Icons.send, color: Colors.white, size: 14),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
