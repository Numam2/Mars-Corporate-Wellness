import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/posts.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:intl/intl.dart';
import 'package:personal_trainer/Screens/Social/PostComment.dart';
import 'package:personal_trainer/Screens/Social/PostHeader.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:provider/provider.dart';

class PostDetails extends StatefulWidget {
  final String groupName;
  final String postID;
  PostDetails({this.groupName, this.postID});

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  String commentPost;
  var _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _post = Provider.of<Post>(context);
    final _user = Provider.of<UserProfile>(context);

    if (_post == null) {
      return Loading();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      //Appbar
      appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          title:
              Text('Comentarios', style: Theme.of(context).textTheme.headline)),

      body: Container(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: <Widget>[
            //View Post and Comments list as scrollable
            Expanded(
                child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  //Post
                  Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                      ),
                      child: Column(children: <Widget>[
                        //Header (User info)
                        StreamProvider<UserProfile>.value(
                          value: DatabaseService().postOwner(_post.ownerUID),
                          child: PostHeader(date: _post.date),
                        ),

                        //Post
                        Container(
                          width: double.infinity,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                //Text Content
                                (_post.type == null || _post.type == '')
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 15),
                                        child: Text(
                                          _post.textContent,
                                          style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 10),
                                        child: Container(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                (_post.type == 'Exercise')
                                                    ? Icon(Icons.fitness_center,
                                                        color: Colors.black,
                                                        size: 20)
                                                    : Icon(Icons.calendar_today,
                                                        color: Colors.black,
                                                        size: 20),
                                                SizedBox(width: 15),
                                                Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Container(
                                                          constraints: BoxConstraints(
                                                              maxWidth: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.75),
                                                          child: Text(
                                                            _post.headline,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .display1,
                                                          )),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        _post.subtitle,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display2,
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        _post.textContent,
                                                        style: GoogleFonts
                                                            .montserrat(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .black),
                                                      ),
                                                    ])
                                              ]),
                                        ),
                                      ),
                                (_post.textContent != null ||
                                        _post.textContent != '')
                                    ? SizedBox(height: 10)
                                    : SizedBox(),

                                //Media
                                (_post.media == null || _post.media == '')
                                    ? Container(height: 0)
                                    : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                constraints: BoxConstraints(maxHeight: 400),
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(_post.media, fit: BoxFit.fitWidth)),
                              )
                            ),

                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Row(
                                    children: <Widget>[
                                      ///Likes
                                      IconButton(
                                        padding: EdgeInsets.all(2),
                                        onPressed: () {
                                          if (_post.likes.contains(_user.uid)) {
                                            DatabaseService().unlikePost(
                                                widget.groupName, _post.postID);
                                            DatabaseService()
                                                .notifyLikesComments(
                                                    _post.ownerUID,
                                                    'Liked Post',
                                                    widget.groupName);
                                          } else {
                                            DatabaseService().likePost(
                                                widget.groupName, _post.postID);
                                          }
                                        },
                                        icon: Icon(
                                          Icons.thumb_up,
                                          color: _post.likes.contains(_user.uid)
                                              ? Colors.blue
                                              : Colors.grey,
                                          size: 16.0,
                                        ),
                                        splashRadius: 16,
                                      ),
                                      SizedBox(width: 2.0),
                                      Text(
                                        NumberFormat.compact()
                                            .format(_post.likes.length)
                                            .toString(),
                                        style: GoogleFonts.montserrat(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      ])),

                  Divider(color: Colors.grey, indent: 40, endIndent: 40),

                  //Comments
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    child: ListView.builder(
                        itemCount: _post.comments.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return StreamProvider<UserProfile>.value(
                              value: DatabaseService()
                                  .postOwner(_post.comments[index].userID),
                              child: PostComment(
                                  commentText: _post.comments[index].comment));
                        }),
                  ),
                ],
              ),
            )),

            //Text Input
            Container(
              color: Colors.grey[50],
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey, width: 0.8),
                      boxShadow: <BoxShadow>[
                        new BoxShadow(
                          color: Colors.grey,
                          offset: new Offset(0.0, 3.0),
                          blurRadius: 5.0,
                        )
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ///Image
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10.0),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey[100],
                          child: ClipOval(
                            child: Container(
                                height: 40,
                                width: 40,
                                child: Image.network(_user.profilePic,
                                    fit: BoxFit.cover)),
                          ),
                        ),
                      ),

                      ///Input Text
                      Container(
                        width: 250,
                        child: TextField(
                          style: GoogleFonts.montserrat(
                              color: Colors.black, fontSize: 14),
                          cursorColor: Theme.of(context).accentColor,
                          autofocus: false,
                          expands: false,
                          maxLines: null,
                          controller: _controller,
                          decoration: InputDecoration.collapsed(
                            hintText: "Comenta...",
                            hintStyle:
                                TextStyle(color: Theme.of(context).canvasColor),
                          ),
                          onChanged: (value) {
                            setState(() => commentPost = value);
                          },
                        ),
                      ),

                      Spacer(),

                      ///Send Button
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: GestureDetector(
                            child: Text('Post',
                                style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    color: Theme.of(context).primaryColor)),
                            onTap: () {
                              DatabaseService().commentPost(
                                  widget.groupName, widget.postID, commentPost);
                              DatabaseService().notifyLikesComments(
                                  _post.ownerUID,
                                  'Comment Post',
                                  widget.groupName);

                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }

                              setState(() {
                                _controller.clear();
                              });
                            }),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
