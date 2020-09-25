import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/messages.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Messages/MyChatRooms.dart';
import 'package:personal_trainer/Screens/Messages/SearchUsers.dart';
import 'package:personal_trainer/Screens/wrapper.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:provider/provider.dart';

class MessagesHome extends StatefulWidget {

  final UserProfile myUserProfile;
  MessagesHome({this.myUserProfile});

  @override
  _MessagesHomeState createState() => _MessagesHomeState();
}

class _MessagesHomeState extends State<MessagesHome> {
  
  String userToSearch;
  var _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  int searchLimit = 6;
  bool loadingNewSearch = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {  

  if (_scrollController.offset >= _scrollController.position.maxScrollExtent) { //&& !_scrollController.position.outOfRange
    
    loadingNewSearch = true;

    Timer(Duration(seconds: 4), () {
      setState(() {
        searchLimit = searchLimit + 5;
        loadingNewSearch = false;       
      });
    });
  }
}

  @override
  Widget build(BuildContext context) {

    final _chats = Provider.of<List<ChatsList>>(context);
    final _user = widget.myUserProfile;

    if (_chats == null || _user == null){
      return Loading();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(        
        backgroundColor: Colors.white,          
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.push(
              context, MaterialPageRoute(builder: (context) => Wrapper()));
          },
          child: Icon(
            Icons.keyboard_arrow_left,
            color: Colors.black,
          ),
        ),
            
        title: Text('Chat',
          style: Theme.of(context).textTheme.headline),        
      ),

      body: WillPopScope(
        onWillPop: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => Wrapper())),
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              //Search Field
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal:20),
                color: Colors.white,
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                        //border: Border.all(color: Colors.grey, width: 0.8),
                        boxShadow: <BoxShadow>[
                          new BoxShadow(
                            color: Colors.grey,
                            offset: new Offset(0.0, 3.0),
                            blurRadius: 5.0,
                          )
                        ]
                      ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ///Icons Button
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20.0),
                          child: Icon(
                            Icons.search, color: Colors.grey, size: 26),
                        ),

                        ///Input Text
                        Container(
                          width: MediaQuery.of(context).size.width*0.5,
                          child: TextFormField(
                            style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                            cursorColor: Theme.of(context).accentColor,
                            autofocus: false,
                            expands: false,
                            maxLines: null,
                            controller: _controller,
                            decoration: InputDecoration.collapsed(
                              hintText: "Busca por nombre...",
                              hintStyle: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[350]),
                            ),
                            onChanged: (value) {
                              setState(() => userToSearch = value);                          
                            },                        
                          ),
                    ),

                    Spacer(),

                    ///Cancel Button
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.black, size: 20),
                        onPressed: () {

                          setState(() {
                            _controller.clear();
                            userToSearch = null;
                          });

                          FocusScopeNode currentFocus = FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();}
                          
                        }),
                    )
                  ],
                )),
              ),

              //Either My Chat Rooms or Search
              (userToSearch == null || userToSearch == '')
               ? MyChatRooms(userProfile:_user)
               : StreamProvider<List<UserProfile>>.value(
                  value: DatabaseService().searchUsers(userToSearch, searchLimit),
                  child: SearchUserstoChat(myUserProfile: _user)
                ),
              
              //Loading new searches
              loadingNewSearch
              ? Container(
                  height: 100,
                  width: double.infinity,
                    child: Loading()
                )
              : SizedBox(height: 50)
            ],
          )         
        ),
      ), 
    );
  }
}