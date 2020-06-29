import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:provider/provider.dart';

class PostComment extends StatelessWidget {

  final String commentText;
  PostComment({this.commentText});

  @override
  Widget build(BuildContext context) {

    final _user = Provider.of<UserProfile>(context);

    if(_user == null){
      return Container();
    }
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child:
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[

        //User Image
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey[100],
          child: ClipOval(
            child: Container(
                height: 40,
                width: 40,
                child: Image.network(
                    _user.profilePic,
                    fit: BoxFit.cover)),
          ),
        ),
        SizedBox(width: 10),

        //User Comment
        Container(
            width: MediaQuery.of(context).size.width * 0.7,
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25.0),
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0)),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _user.name,
                    style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 3),
                  Text(
                    (_user.about == null || _user.about == '') 
                    ? _user.name
                    : _user.about,
                    style: GoogleFonts.montserrat(
                        fontSize: 11,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  Text(
                    commentText,
                    style: GoogleFonts.montserrat(
                        color: Colors.black, fontSize: 12),
                  ),
                ])),
      ]),
    );
  }
}
