import 'package:flutter/material.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/messages.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Messages/ChatCoach.dart';
import 'package:personal_trainer/Screens/Messages/MessageUserData.dart';
import 'package:personal_trainer/Screens/Messages/MessageUserDeleted.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:provider/provider.dart';

class MyChatRooms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final _chats = Provider.of<List<ChatsList>>(context);
    final _user = Provider.of<UserProfile>(context);

    if (_chats == null || _user == null){
      return Loading();
    }

    return Container(
      padding: EdgeInsets.only(bottom: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          
          ///Greetings Text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
              child: Text(
                "Mensajes",
                style: Theme.of(context).textTheme.title,
                  textAlign: TextAlign.left,
              ),
          ),

          ///Chat With Coach
          _user.hasPersonalCoach ? SizedBox() : ChatCoach(user:_user.uid),

          ///Chat Rooms          
          Container(
            width: double.infinity,
            child: ListView.builder(
              itemCount: _chats.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){

                if (_chats[index].users.length < 2){

                  return MessagesUserDeleted(chatDocID: _chats[index].docID);

                } else if  (_chats[index].userReads.length == 2) {

                  final bool thisUser = _chats[index].users.elementAt(0) == _user.uid;
                  final bool thisuserReadIndex = _chats[index].userReads.elementAt(0).user == _user.uid;

                  final String otherUserUID = thisUser
                    ? _chats[index].users.elementAt(1) : _chats[index].users.elementAt(0);

                  final DateTime lastRead = thisuserReadIndex
                    ? _chats[index].userReads.elementAt(0).lastChecked : _chats[index].userReads.elementAt(1).lastChecked;

                  return StreamProvider<UserProfile>.value(
                    value: DatabaseService().postOwner(otherUserUID),
                    child: MessagesUserData(
                        myUID: _user.uid,
                        usersinChat: _chats[index].users.length,
                        chatDocID: _chats[index].docID, 
                        lastMessageTime: _chats[index].lastMessageTime,
                        lastRead: lastRead,
                      ));

                } else {

                  return MessagesLoading();

                }
              }
            ),
          ),

        ],
      )

    );
  }
}