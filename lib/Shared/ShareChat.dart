import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/messages.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Home/Inicio_Navigate.dart';
import 'package:personal_trainer/Shared/ShareChatUserData.dart';
import 'package:provider/provider.dart';

class ShareChat extends StatefulWidget {
  final String type;
  final String headline;
  final String time;
  final IconData activityIcon;
  ShareChat({this.type, this.headline, this.time, this.activityIcon});

  @override
  _ShareChatState createState() => _ShareChatState();
}

class _ShareChatState extends State<ShareChat> {
  var _controller = TextEditingController();

  String commentPost = '';

  @override
  Widget build(BuildContext context) {

    final _chats = Provider.of<List<ChatsList>>(context);
    final _user = Provider.of<UserProfile>(context);

    if (_chats == null || _user == null){
      return SizedBox();
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Container(
        height: 500,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Close
              Row(
                children:<Widget>[
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back_ios),
                      iconSize: 15.0),
                  Spacer(),
                  IconButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder:(context) => InicioNew())),
                      icon: Icon(Icons.close),
                      iconSize: 15.0),
                ] 
              ),
              //Content
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: <Widget>[
                    //Customized Header
                    Container(
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(widget.activityIcon, color: Colors.black),
                          SizedBox(width: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                constraints: BoxConstraints(maxWidth: 160),
                                child: Text(
                                  widget.headline, style: Theme.of(context).textTheme.display1,
                                )
                              ),
                              SizedBox(height: 5),
                              Text(
                                widget.time, style: Theme.of(context).textTheme.display2,
                              )
                            ])
                        ]),
                      ),
                    //Text Input
                    Container(
                      padding: EdgeInsets.only(left: 15),
                      constraints: BoxConstraints(maxWidth: 200, maxHeight: 100),
                      child: TextField(
                        style: GoogleFonts.montserrat(
                            color: Colors.black, fontSize: 12),
                        cursorColor: Theme.of(context).accentColor,
                        autofocus: false,
                        expands: false,
                        maxLines: null,
                        inputFormatters: [LengthLimitingTextInputFormatter(75)],
                        controller: _controller,
                        decoration: InputDecoration.collapsed(
                          hintText: "Escribe un mensaje",
                          hintStyle: TextStyle(color: Colors.grey.shade700),
                        ),
                        onChanged: (value) {
                          setState(() => commentPost = value);
                        },
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              SizedBox(height: 10),
              //List Chat Rooms
              (_chats.length != 0)
              ? Flexible(
                fit: FlexFit.loose,
                child: Container(
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: _chats.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index){

                      if (_chats[index].users.length == 0){

                        return SizedBox();

                      } else {

                        final bool thisUser = _chats[index].users.elementAt(0) == _user.uid;
                        final bool thisuserReadIndex = _chats[index].userReads.elementAt(0).user == _user.uid;

                        final String otherUserUID = thisUser
                          ? _chats[index].users.elementAt(1) : _chats[index].users.elementAt(0);

                        final DateTime lastRead = thisuserReadIndex
                          ? _chats[index].userReads.elementAt(0).lastChecked : _chats[index].userReads.elementAt(1).lastChecked;

                        return StreamProvider<UserProfile>.value(
                          value: DatabaseService().postOwner(otherUserUID),
                          child: ShareChatUserData(
                              myUID: _user.uid,
                              usersinChat: _chats[index].users.length,
                              chatDocID: _chats[index].docID, 
                              lastMessageTime: _chats[index].lastMessageTime,
                              lastRead: lastRead,

                              type: widget.type,
                              headline: widget.headline,
                              time: widget.time,
                              text: commentPost,
                          ));

                      }
                    }
                  ),
                ),
              )
              : Container(
                height: 200,
                child: Center(
                  child: Text(
                    'No tienes conversaciones activas para compartir',
                    style: Theme.of(context).textTheme.body1
                  ),
                )
              )


            ],
          ),
        ),
      ),
    );
  }
}
