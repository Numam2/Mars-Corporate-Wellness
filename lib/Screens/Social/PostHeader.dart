import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostHeader extends StatelessWidget {

  final DateTime date;
  PostHeader({Key key, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _postOwner = Provider.of<UserProfile>(context);

    if (_postOwner == null){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          height: 50,
          width: double.infinity,
          child: Text(''),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: double.infinity,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ///Image
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey[100],
                child: ClipOval(
                  child: Container(
                      height: 50,
                      width: 50,
                      child: Image.network(
                          _postOwner.profilePic,
                          fit: BoxFit.cover)),
                ),
              ),
              SizedBox(width: 15),

              ///Userifo
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.35
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ///Username
                      Text(
                        _postOwner.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      SizedBox(height: 5),

                      ///User Bio
                      Text(
                        (_postOwner.about == null || _postOwner.about == '')
                        ?_postOwner.name
                        :_postOwner.about,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                            fontSize: 11,
                            fontWeight: FontWeight.w300,
                            color: Colors.black),
                      ),
                    ]),
              ),

              Spacer(),

              ///TimeStamp
              Row(children: <Widget>[
                Icon(
                  Icons.access_time,
                  color: Colors.grey,
                  size: 12.0,
                ),
                SizedBox(width: 5.0),
                Text(
                  timeago.format(date, locale: 'es'),
                  style: GoogleFonts.montserrat(
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                      color: Colors.black),
                ),
              ]),
            ]),
      ),
    );
  }
}
