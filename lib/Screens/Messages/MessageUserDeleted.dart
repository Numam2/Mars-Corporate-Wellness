import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Screens/Messages/ChatDelete.dart';

class MessagesUserDeleted extends StatelessWidget {

  final String chatDocID;
  MessagesUserDeleted({this.chatDocID});

  @override
  Widget build(BuildContext context) {

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
                    chatDocID: chatDocID,
                    usersinChat: 1);
                    });
            },
          ),
        ],
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
                      'https://firebasestorage.googleapis.com/v0/b/ludus-health-coach.appspot.com/o/Profile Images/No User.png?alt=media&token=0312211c-026c-432b-98b5-e4e03bcbe386',
                      fit: BoxFit.cover)),
                ),
              ),
              SizedBox(width: 15),

              Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.5),
                child: Text(
                  'Este chat fue eliminado por el otro usuario - Desliza para eliminar',
                  style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey[800]),
                ),
              ),

            ],
          ),
        ),
      );
  }
}
