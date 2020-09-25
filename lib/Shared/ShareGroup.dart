import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/groups.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Home/Inicio_Navigate.dart';
import 'package:personal_trainer/Shared/ShareGroupData.dart';
import 'package:provider/provider.dart';

class ShareGroup extends StatefulWidget {
  final String type;
  final String headline;
  final String time;
  final IconData activityIcon;
  ShareGroup({this.type, this.headline, this.time, this.activityIcon});

  @override
  _ShareGroupState createState() => _ShareGroupState();
}

class _ShareGroupState extends State<ShareGroup> {
  var _controller = TextEditingController();

  String commentPost = '';

  @override
  Widget build(BuildContext context) {

    final _group = Provider.of<List<Groups>>(context);
    final _user = Provider.of<UserProfile>(context);

    if (_group == null || _user == null){
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
                padding: EdgeInsets.symmetric(horizontal: 5),
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
                    SizedBox(height: 10),
                    //Text Input
                    Container(
                      // padding: EdgeInsets.only(left: 15),
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
              (_group.length != 0)
              ? Flexible(
                fit: FlexFit.loose,
                child: Container(
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: _group.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index){

                      if (_group.length == 0){

                        return SizedBox();

                      } else {
                        
                        return StreamProvider<Groups>.value(
                          value: DatabaseService().groupData(_group[index].groupName),
                          child: ShareGroupData(
                              myUID: _user.uid,
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
                    'No tienes grupos para compartir',
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
