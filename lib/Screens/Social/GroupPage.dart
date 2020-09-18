import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/groups.dart';
import 'package:personal_trainer/Models/posts.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Social/CreatePost.dart';
import 'package:personal_trainer/Screens/Social/GroupFeed.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:provider/provider.dart';

class GroupPage extends StatefulWidget {

  final String groupName;
  GroupPage({this.groupName});

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {

  //////////To refresh page
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
    new GlobalKey<RefreshIndicatorState>();
  bool refreshed = false;

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      refreshed = true;
      print (refreshed);
    });
    return null;
  }

  ////////To load more posts when scrolling
  ScrollController _scrollController = ScrollController();
  List<Post> postList = [];
  bool loadingMorePosts = false;

   _loadMorePosts () async {

    loadingMorePosts = true;
    
    QuerySnapshot qn = await FirebaseFirestore.instance.collection('Groups').doc(widget.groupName).collection('Posts')
    .orderBy('Time', descending: true)
    .startAfter([postList.last.date])
    .limit(15)
    .get(); //snapshots().map(_messagesListFromSnapshot);

    List<Post> newList = qn.docs.map((doc){
      return Post(
        postID: doc.data()['Post ID'],
        ownerUID: doc.data()['Owner ID'],
        date: doc.data()['Time'].toDate(),
        likes: doc.data()['Likes'] ?? [],
        textContent: doc.data()['Text Content'] ?? '',
        media: doc.data()['Media'] ?? '',
        location: doc.data()['Location'] ?? '',
        comments: doc.data()["Comments"].map<PostComments>((item){
          return PostComments(
            userID: item['Sender'] ?? '',
            comment: item['Comment'] ?? '',            
          );
          }).toList(),
        );
      }
    ).toList();
    
    setState(() {
      postList.addAll(newList);
    });

    loadingMorePosts = false;
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener((){

      if(_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange){
        _loadMorePosts();
      }

    });
  }

  @override
  Widget build(BuildContext context) {

    final _profile = Provider.of<UserProfile>(context);
    final _post = Provider.of<List<Post>>(context);
    final _group = Provider.of<Groups>(context);

    postList = _post;

    if (_group == null || _profile == null){
      return Loading();
    }
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,          
        centerTitle: true,
        leading: InkWell(
            onTap:() {Navigator.pop(context);},
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,),
            ),
        title: Text(widget.groupName,
          style: Theme.of(context).textTheme.headline),        
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(      
        onPressed: (){
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => CreatePost(groupName: _group.groupName)));
        },
        backgroundColor: Theme.of(context).accentColor,
        child: Icon(
          Icons.comment,
          color: Colors.white
        ),
      ),
      
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        color: Colors.black,
        key: _refreshIndicatorKey,
        onRefresh:()async{

          if (loadingMorePosts = true){
            print('Reload already in progress');
          } else {
            await _refresh();
          }
          
        },
        
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[

              ///Group Details
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(20,20,20,30),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    boxShadow: <BoxShadow>[
                      new BoxShadow(
                        color: Colors.grey,
                        offset: new Offset(0.0, 3.0),
                        blurRadius: 5.0,
                      )
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    ///Private?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        _group.private 
                          ? Icon(Icons.lock_outline, color: Colors.grey, size: 14)
                          : Icon(Icons.people, color: Colors.grey, size: 14),                      
                        SizedBox(width: 5),
                        _group.private
                          ? Text('privado', style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w300))
                          : Text('público', style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w300))
                      ],
                    ),
                    
                    ///Image                    
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[100],
                      child: ClipOval(
                        child: Container(
                          height: 120,
                          width: 120,
                          child: Image.network(_group.groupImage, fit: BoxFit.cover)
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    ///Name of Group
                    Text(
                      _group.groupName,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                    ),
                    SizedBox(height: 10),

                    ///MemberCount
                    Text(
                      NumberFormat.compact().format(_group.memberCount).toString() + ' miembros',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                    ),
                    SizedBox(height: 20),

                    ///MemberCount
                    Text(
                      _group.description,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 25),

                    ///Buttons Follow/Unfollow + Share
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:<Widget>[
                        Container(
                          height: 40,
                          width: 100,
                          child: 
                          (_profile.groups.contains(_group.groupName)) 
                          
                          ?
                          Container(
                            height: 35.0,
                            width: 120,
                            child: RaisedButton(
                              onPressed: () {
                                DatabaseService().leaveGroupList(_group.groupName, _group.memberCount);
                                DatabaseService().deleteMyGroup(_group.groupName);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              padding: EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).accentColor,
                                  border: Border.all(color: Theme.of(context).accentColor, width: 0.8),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Container(
                                  constraints: BoxConstraints(
                                    minHeight: 50.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "SALIR",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
                            
                          :
                          Container(
                            height: 35.0,
                            width: 120,
                            child: RaisedButton(
                              onPressed: () {

                                if(_group.private){
                                  DatabaseService().askJoinPrivateGroup(_group.admin, _group.groupName);
                                } else {
                                  DatabaseService().joinGroupList(_group.groupName, _group.memberCount);
                                  DatabaseService().addMyGroup(_group.groupName);
                                }
                                
                              },
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                              padding: EdgeInsets.all(0.0),
                              child: Ink(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).accentColor,
                                    border: Border.all(color: Theme.of(context).accentColor, width: 0.8),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                child: Container(
                                  constraints: BoxConstraints(maxWidth: 200.0, minHeight: 50.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "UNIRME",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12, fontWeight: FontWeight.w500 ,color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          )),

                          SizedBox(width: 20),

                          Container(
                            height: 35.0,
                            width: 100,
                            child: RaisedButton(
                              onPressed: () {
                                // DatabaseService().leaveGroupList(_group.groupName, _group.memberCount);
                                // DatabaseService().deleteMyGroup(_group.groupName);
                              },
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                              padding: EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Theme.of(context).accentColor, width: 0.8),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Container(
                                  constraints: BoxConstraints(maxWidth: 200.0, minHeight: 50.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "COMPARTIR",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12, fontWeight: FontWeight.w500 ,color: Theme.of(context).accentColor),
                                  ),
                                ),
                              ),
                            ),
                          )
                          
                      ]
                    )

                  ],
                )
              ),
              SizedBox(height: 10),
              
              (_group.private && !_group.members.contains(_profile.uid))
              ? Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    boxShadow: <BoxShadow>[
                      new BoxShadow(
                        color: Colors.grey,
                        offset: new Offset(0.0, 3.0),
                        blurRadius: 5.0,
                      )
                    ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:<Widget>[
                      Icon(Icons.lock_outline, color: Colors.grey[300], size: 50),
                      SizedBox(width:20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Este grupo es privado',
                            style: Theme.of(context).textTheme.display1,
                          ),
                          SizedBox(height: 10),
                          Text('Únete al grupo para poder ver el feed',
                            style: Theme.of(context).textTheme.body1,
                          ),
                        ],
                      ),
                    ])
                )
              : GroupFeed(groupName: _group.groupName, post: postList)
            ],
          ),
        ),
      )
    );
  }
}