import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/posts.dart';
import 'package:personal_trainer/Screens/Social/CompanyFeed.dart';
import 'package:personal_trainer/Screens/Social/FeedArticlesList.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:provider/provider.dart';

class CompanyPage extends StatefulWidget {

  final String organizationName;
  CompanyPage({this.organizationName});

  @override
  _CompanyPageState createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {

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
    
    QuerySnapshot qn = await FirebaseFirestore.instance.collection('Organizations').doc(widget.organizationName).collection('Posts')
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

    final _post = Provider.of<List<Post>>(context);    

    if (_post == null){
      return Loading();
    }

    postList = _post;
    
    return RefreshIndicator(
        backgroundColor: Colors.white,
        color: Colors.black,
        key: _refreshIndicatorKey,
        onRefresh:()async{

          if (loadingMorePosts = true){
          } else {
            await _refresh();
          }
          
        },      
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[

              ///Articles Card
              StreamProvider<List<Article>>.value(
                value: DatabaseService().articles(widget.organizationName),
                child: FeedArticlesList(organizationName: widget.organizationName)
              ),

              SizedBox(height: 10),
              
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: CompanyFeed(groupName: widget.organizationName, post: postList),
              )
            ],
          ),
        ),
    );
  }
}