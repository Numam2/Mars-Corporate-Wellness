import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/groups.dart';
import 'package:provider/provider.dart';

class ShareGroupData extends StatefulWidget {
  final String myUID;

  final String type;
  final String headline;
  final String time;
  final String text;

  ShareGroupData({this.myUID, this.type, this.headline, this.time, this.text});

  @override
  _ShareGroupDataState createState() => _ShareGroupDataState();
}

class _ShareGroupDataState extends State<ShareGroupData> {

  bool messageSent = false;

  @override
  Widget build(BuildContext context) {

    final _group = Provider.of<Groups>(context);

    if (_group == null){
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
                  _group.groupImage,
                  fit: BoxFit.cover)),
            ),
          ),
          SizedBox(width: 10),
          //User Name and BIO
          Container(
            width: MediaQuery.of(context).size.width*0.35,
            child: Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.35),
              child: Text(
                _group.groupName,
                style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ),
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
                DatabaseService().createSharedPost(_group.groupName, widget.text, widget.type, widget.headline, widget.time);                           
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
