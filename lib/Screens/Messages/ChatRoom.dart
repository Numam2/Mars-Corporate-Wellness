import 'package:flutter/material.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/messages.dart';
import 'package:personal_trainer/Screens/Messages/ChatMessages.dart';
import 'package:personal_trainer/Screens/Messages/MessageHome.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatelessWidget {

  final String myUID;
  final String docID;
  final String profilePic;
  final String name;
  final DateTime lastRead;
  ChatRoom({Key key, this.myUID, this.docID, this.profilePic, this.name, this.lastRead}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _chat = Provider.of<ChatsList>(context);

    return StreamProvider<List<Messages>>.value(
      value: DatabaseService().messages(docID),
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            leading: InkWell(
              onTap: () async {

                Navigator.push(context, MaterialPageRoute(builder: (context) => MessagesHome()));
                
                final bool thisuserReadIndex = _chat.userReads.elementAt(0).user == myUID;
                final DateTime lastRead = thisuserReadIndex
                  ? _chat.userReads.elementAt(0).lastChecked : _chat.userReads.elementAt(1).lastChecked;

                await DatabaseService().deletePreviousLastRead(docID, lastRead);
                await DatabaseService().updateMyLastRead(docID);
                
              },
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            centerTitle: true,
            title: Text(name,
                style: Theme.of(context).textTheme.headline),
            actions:[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[100],
                  child: ClipOval(
                    child: Container(
                        height: 40,
                        width: 40,
                        color: Colors.grey,
                        child: Image.network(
                        profilePic,
                        fit: BoxFit.cover)),
                  ),
                ),
              ),
            ]
              
        ),

        body: ChatMessages(docID: docID)
        
      ),
    );
  }
}