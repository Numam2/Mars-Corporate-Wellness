import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/posts.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Social/PostDetails.dart';
import 'package:personal_trainer/Screens/Social/PostHeader.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:provider/provider.dart';

class CompanyFeed extends StatefulWidget {

  final String groupName;
  final List<Post> post;
  CompanyFeed({this.groupName, this.post});

  @override
  _CompanyFeedState createState() => _CompanyFeedState();
}

class _CompanyFeedState extends State<CompanyFeed> {

  bool canExpand = false;
  bool isExpand = false;
  String postText;
  
  @override
  Widget build(BuildContext context) {

    final _post = widget.post;
    final _user = Provider.of<UserProfile>(context);

    if (_post == null){
      return Container(height: 150, child: Center(child: Loading()));
    }
    

    return Container(
      width: double.infinity,
      child: ListView.builder(
        itemCount: _post.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index){

          postText = _post[index].textContent;

          canExpand = postText != null && postText.length >= 100;
          postText = canExpand
              ? (isExpand ? postText : postText.substring(0, 100) + '...')
              : (postText);

          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Container(
              width: double.infinity,              
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
              child: Column(children:<Widget>[

                  //Header (User info)
                  StreamProvider<UserProfile>.value(
                    value: DatabaseService().postOwner(_post[index].ownerUID),
                    child: PostHeader(date: _post[index].date),
                  ),

                  //Post
                  (_post[index].type == null || _post[index].type == '')
                  ? Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:<Widget>[
                          
                          //Text Content
                          canExpand                       
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                              child: Column(
                                children:<Widget>[
                                  Text(
                                    postText,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children:<Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isExpand = !isExpand;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 4.0, left: 10, right: 10),
                                          child: Text(
                                            isExpand ? 'mostar menos' : ' ... mostrar mas',
                                            style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.blue),                                    
                                          )
                                        )
                                      ),
                                    ] 
                                  )
                                ] 
                              ),
                            )                          
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                              child: Text(
                                postText,
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                              ),
                            ),

                          //Media
                          (_post[index].media == '' || _post[index].media == null)
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                constraints: BoxConstraints(maxHeight: 400),
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(_post[index].media, fit: BoxFit.fitWidth)),
                              )
                            ),

                          //Likes / comments
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: <Widget>[
                                ///Likes
                                IconButton(
                                  padding: EdgeInsets.all(2),
                                  onPressed: () {
                                    if(_post[index].likes.contains(_user.uid)){
                                      DatabaseService().unlikePost(widget.groupName, _post[index].postID);
                                      DatabaseService().notifyLikesComments(_post[index].ownerUID, 'Liked Post', widget.groupName);
                                    } else {
                                      DatabaseService().likePost(widget.groupName, _post[index].postID);
                                    }
                                  },
                                  icon: Icon(
                                    Icons.thumb_up,
                                    color: _post[index].likes.contains(_user.uid) ? Colors.blue : Colors.grey,
                                    size: 16.0,
                                  ),
                                  splashRadius: 16,
                                ),
                                SizedBox(width: 2.0),
                                Text(
                                  NumberFormat.compact().format(_post[index].likes.length).toString(),
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                                ),
                                SizedBox(width: 20.0),

                                ///Comments
                                IconButton(
                                  padding: EdgeInsets.all(2),
                                  onPressed: (){
                                    Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => 
                                      StreamProvider<Post>.value(
                                        value: DatabaseService().post(widget.groupName, _post[index].postID),
                                        child: PostDetails(groupName: widget.groupName, postID:_post[index].postID),
                                      )));
                                  },
                                  icon: Icon(
                                    Icons.textsms,
                                    color: Colors.grey,
                                    size: 16.0,
                                  ),
                                  splashRadius: 16,
                                ),
                                SizedBox(width: 5.0),
                                Text(
                                  NumberFormat.compact().format(_post[index].comments.length).toString(),
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                            

                        ]
                      )
                      
                    )
                  : Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:<Widget>[

                          //Shared Post
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                            child: Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  (_post[index].type == 'Exercise')
                                      ? Icon(Icons.fitness_center, color: Colors.black, size: 20)
                                      : Icon(Icons.calendar_today, color: Colors.black, size: 20),
                                  SizedBox(width: 15),
                                  Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.75),
                                            child: Text(
                                              _post[index].headline,
                                              style: Theme.of(context).textTheme.display1,
                                            )),
                                        SizedBox(height: 5),
                                        Text(
                                          _post[index].subtitle,
                                          style: Theme.of(context).textTheme.display2,
                                        )
                                      ])
                                ]),
                            ),
                          ),
                          (postText != null || postText != '') ? SizedBox(height: 10) : SizedBox(),
                          
                          //Text Content
                          (postText.length != 0)
                          ? Container(
                          child: canExpand                       
                          ? Padding(
                              padding: EdgeInsets.only(left: 55, right: 20.0),
                              child: Column(
                                children:<Widget>[
                                  Text(
                                    postText,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children:<Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isExpand = !isExpand;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 4.0, left: 10, right: 10),
                                          child: Text(
                                            isExpand ? 'mostar menos' : ' ... mostrar mas',
                                            style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.blue),                                    
                                          )
                                        )
                                      ),
                                    ] 
                                  )
                                ] 
                              ),
                            )                          
                          : Padding(
                              padding: EdgeInsets.only(left: 55, right: 20.0, bottom: 15),
                              child: Text(
                                postText,
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                              ),
                            ),
                          )
                          : SizedBox(),
                          //Media
                          (_post[index].media == '' || _post[index].media == null)
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                constraints: BoxConstraints(maxHeight: 400),
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(_post[index].media, fit: BoxFit.fitWidth)),
                              )
                            ),

                          //Likes / comments
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: <Widget>[
                                ///Likes
                                IconButton(
                                  padding: EdgeInsets.all(2),
                                  onPressed: () {
                                    if(_post[index].likes.contains(_user.uid)){
                                      DatabaseService().unlikePost(widget.groupName, _post[index].postID);
                                      DatabaseService().notifyLikesComments(_post[index].ownerUID, 'Liked Post', widget.groupName);
                                    } else {
                                      DatabaseService().likePost(widget.groupName, _post[index].postID);
                                    }
                                  },
                                  icon: Icon(
                                    Icons.thumb_up,
                                    color: _post[index].likes.contains(_user.uid) ? Colors.blue : Colors.grey,
                                    size: 16.0,
                                  ),
                                  splashRadius: 16,
                                ),
                                SizedBox(width: 2.0),
                                Text(
                                  NumberFormat.compact().format(_post[index].likes.length).toString(),
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                                ),
                                SizedBox(width: 20.0),

                                ///Comments
                                IconButton(
                                  padding: EdgeInsets.all(2),
                                  onPressed: (){
                                    Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => 
                                      StreamProvider<Post>.value(
                                        value: DatabaseService().post(widget.groupName, _post[index].postID),
                                        child: PostDetails(groupName: widget.groupName, postID:_post[index].postID),
                                      )));
                                  },
                                  icon: Icon(
                                    Icons.textsms,
                                    color: Colors.grey,
                                    size: 16.0,
                                  ),
                                  splashRadius: 16,
                                ),
                                SizedBox(width: 5.0),
                                Text(
                                  NumberFormat.compact().format(_post[index].comments.length).toString(),
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                             

                        ]
                      )
                      
                    ),
                    
                    Divider(indent: 20, endIndent: 20, color: Colors.grey[350])
                ]    
              ),

            ),
          );
        }      
      ),
    );
  }
}
