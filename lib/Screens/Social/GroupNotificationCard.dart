import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/groups.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class GroupNotificationCard extends StatelessWidget {

  final String type;
  final DateTime date;

  GroupNotificationCard({this.type, this.date});

  @override
  Widget build(BuildContext context) {
    
    final _sender = Provider.of<UserProfile>(context);
    final _group = Provider.of<Groups>(context);

    if(_sender == null || _group == null){
      return Center(child: Loading());
    } else if (type == 'Join Request'){
       return Container(
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
                    child: Image.network(_sender.profilePic, fit: BoxFit.cover)),
              ),
            ),
            SizedBox(width: 15),

            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.4),
                    child: Text(
                      _sender.name + ' quiere unirse al grupo ' + _group.groupName,
                      style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    timeago.format(date, locale: 'es_short'),
                    style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey[800]),
                  ),
                ]),

            Spacer(),
            IconButton(
              onPressed: () {
                DatabaseService().senderjoinGroupList(_sender.uid, _group.groupName, _group.memberCount);
                DatabaseService().addSenderGroup(_sender.uid, _group.groupName);
                DatabaseService().acceptinPrivateGroup(_sender.uid, _group.groupName);
                DatabaseService().deleteGroupNotification(date, _group.groupName, type, _sender.uid);
              },
              icon: Icon(Icons.check, color: Colors.green, size: 20),
            ),
            IconButton(
              onPressed: () {
                DatabaseService().deleteGroupNotification(date, _group.groupName, type, _sender.uid);
              },
              icon: Icon(Icons.close, color: Colors.black, size: 20),
            ),
          ],
        ),
      );
    } else if (type == 'Join Request Accepted'){
      return Container(
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
                    child: Image.network(_group.groupImage, fit: BoxFit.cover)),
              ),
            ),
            SizedBox(width: 15),

            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.4),
                    child: Text(
                      'Has sido aceptad@ al grupo ' + _group.groupName,
                      style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    timeago.format(date, locale: 'es_short'),
                    style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey[800]),
                  ),
                ]),

            Spacer(),            
            IconButton(
              onPressed: () {
                DatabaseService().deleteGroupNotification(date, _group.groupName, type, _sender.uid);
              },
              icon: Icon(Icons.close, color: Colors.black, size: 20),
            )
          ],
        ),
      );
    } else if (type == 'Liked Post'){
      return Container(
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
                    child: Image.network(_sender.profilePic, fit: BoxFit.cover)),
              ),
            ),
            SizedBox(width: 15),

            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.4),
                    child: Text(
                      _sender.name + ' le dio like a tu post en ' + _group.groupName,
                      style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    timeago.format(date, locale: 'es_short'),
                    style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey[800]),
                  ),
                ]),

            Spacer(),            
            IconButton(
              onPressed: () {
                DatabaseService().deleteGroupNotification(date, _group.groupName, type, _sender.uid);
              },
              icon: Icon(Icons.close, color: Colors.black, size: 20),
            )
          ],
        ),
      );
    } else if (type == 'Comment Post'){
      return Container(
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
                    child: Image.network(_sender.profilePic, fit: BoxFit.cover)),
              ),
            ),
            SizedBox(width: 15),

            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.4),
                    child: Text(
                      _sender.name + ' comentó en tu post en ' + _group.groupName,
                      style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    timeago.format(date, locale: 'es_short'),
                    style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey[800]),
                  ),
                ]),

            Spacer(),            
            IconButton(
              onPressed: () {
                DatabaseService().deleteGroupNotification(date, _group.groupName, type, _sender.uid);
              },
              icon: Icon(Icons.close, color: Colors.black, size: 20),
            )
          ],
        ),
      );
    }

    ///If nothing
    return SizedBox();

  }
}
