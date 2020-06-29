import 'package:flutter/material.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/groups.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Social/GroupNotificationCard.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:provider/provider.dart';

class GroupNotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final _notification = Provider.of<GroupNotificationList>(context);

    if (_notification == null){
      return Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Center(
          child: Loading(),
        )
      );
    } else if (_notification.groupNotifications.length == 0){
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title:
              Text('Notificaciones', style: Theme.of(context).textTheme.headline),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
        ),
        body: Container(
          height: 200,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
              Icon(Icons.notifications_off, size: 30, color: Colors.grey),
              SizedBox(height:10),
              Text('No tienes notificaciones',
                style: Theme.of(context).textTheme.body1,
              ),
            ] 
          )
        )
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title:
            Text('Notificaciones', style: Theme.of(context).textTheme.headline),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.close,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: _notification.groupNotifications.length,
        itemBuilder: (context, index){
          return MultiProvider(
            providers: [
              StreamProvider<UserProfile>.value(value: DatabaseService().postOwner(_notification.groupNotifications[index].senderID)),
              StreamProvider<Groups>.value(value: DatabaseService().groupData(_notification.groupNotifications[index].group)),
            ],           
            child: GroupNotificationCard(
              type: _notification.groupNotifications[index].type,
              date: _notification.groupNotifications[index].date,
            ),
          );
        }
      )
    );
  }
}
