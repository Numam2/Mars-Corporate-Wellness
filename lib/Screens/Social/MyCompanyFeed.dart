import 'package:flutter/material.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/organization.dart';
import 'package:personal_trainer/Models/posts.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Social/CompanyPage.dart';
import 'package:personal_trainer/Screens/Social/CreatePost.dart';
import 'package:personal_trainer/Screens/Social/GroupNotifications.dart';
import 'package:provider/provider.dart';

class MyCompanyFeed extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final _organization = Provider.of<Organization>(context);
    final _notification = Provider.of<GroupNotificationList>(context);

    if(_organization == null || _notification == null){
      return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GroupNotificationPage()));
            },
            child: Container(
                    height: 50,
                    width: 60,
                    child: Center(
                      child: Align(
                          alignment: Alignment.center,
                          child: Icon(Icons.notifications_none,
                              color: Colors.black)),
                    ),
                  )),
        title: Text(
          'Feed',
          style: Theme.of(context).textTheme.headline,
        ),
        actions:[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[100],
              child: ClipOval(
                child: Container(
                    height: 40,
                    width: 40,
                    color: Colors.grey[200],
                  ),
              ),
            ),
          ),
        ]
      ),
        body: Container()
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GroupNotificationPage()));
            },
            child: 
            (_notification.groupNotifications.length > 0)
                ? Container(
                    height: 50,
                    width: 60,
                    child: Center(
                      child: Stack(children: <Widget>[
                        Align(
                            alignment: Alignment.center,
                            child: Icon(Icons.notifications_none,
                                color: Colors.black)),
                        Align(
                          alignment: Alignment(0.25, -0.4),
                          child: Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ]),
                    ),
                  )
                : 
                Container(
                    height: 50,
                    width: 60,
                    child: Center(
                      child: Align(
                          alignment: Alignment.center,
                          child: Icon(Icons.notifications_none,
                              color: Colors.black)),
                    ),
                  )),
        title: Text(
          'Feed',
          style: Theme.of(context).textTheme.headline,
        ),
        actions:[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[100],
              child: ClipOval(
                child: Container(
                    height: 40,
                    width: 40,
                    color: Colors.grey,
                    child: Image.network(_organization.logo,fit: BoxFit.cover)
                  ),
              ),
            ),
          ),
        ]
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(      
        onPressed: (){
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => CreatePost(groupName: _organization.organizationName)));
        },
        backgroundColor: Theme.of(context).accentColor,
        child: Icon(
          Icons.comment,
          color: Colors.white
        ),
      ),
      body: StreamProvider<List<Post>>.value(
        value: DatabaseService().groupFeed(_organization.organizationName),
        child: CompanyPage(organizationName: _organization.organizationName)),
    );
  }
}