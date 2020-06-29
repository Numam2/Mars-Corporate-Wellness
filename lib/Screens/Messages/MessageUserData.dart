import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/messages.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Messages/ChatDelete.dart';
import 'package:personal_trainer/Screens/Messages/ChatRoom.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:provider/provider.dart';

class MessagesUserData extends StatelessWidget {
  final String myUID;
  final int usersinChat;
  final String chatDocID;
  final DateTime lastMessageTime;
  final DateTime lastRead;
  MessagesUserData({this.chatDocID, this.lastMessageTime, this.lastRead, this.myUID, this.usersinChat});

  @override
  Widget build(BuildContext context) {

    final _user = Provider.of<UserProfile>(context);

    if (_user == null || lastRead == null){
      return MessagesLoading();
    }
  
    return Slidable(
      actionPane: SlidableStrechActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        IconSlideAction(
          color: Colors.white,
          iconWidget: Icon(Icons.delete, color: Colors.black),
          onTap: () {
            return showDialog(
              context: context,
              builder: (context) {
                return ChatDelete(
                  chatDocID:chatDocID,
                  usersinChat: usersinChat);
                  });
          },
        ),
      ],
      child: InkWell(
          onTap: () async {

             Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StreamProvider<ChatsList>.value(
                      value: DatabaseService().selectedChat(chatDocID),
                      child: ChatRoom(
                        myUID: myUID,
                        docID: chatDocID, 
                        profilePic: _user.profilePic, 
                        name: _user.name,
                      ),
                    )));

            await DatabaseService().updateMyLastRead(chatDocID);
            await DatabaseService().deletePreviousLastRead(chatDocID, lastRead);
            
           
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                        child: Image.network(
                        _user.profilePic,
                        fit: BoxFit.cover)),
                  ),
                ),
                SizedBox(width: 15),

                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        _user.name,
                        style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 3),

                      (_user.about == null || _user.about == '')
                      ?  Text(
                        _user.name,
                        style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey[800]),
                      )
                      : Text(
                        _user.about,
                        style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey[800]),
                      ),
                    ]),

                Spacer(),

                (lastRead.isBefore(lastMessageTime))
                ? Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).accentColor
                      )
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Text(
                      (lastMessageTime.day == DateTime.now().day)
                      ? DateFormat('h:mm a').format(lastMessageTime)
                      : DateFormat.yMd().format(lastMessageTime),
                      style: Theme.of(context).textTheme.display2,
                    ),
                  ),

              ],
            ),
          )),
    );
  }
}
