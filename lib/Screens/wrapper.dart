import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/messages.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Authenticate/authenticate.dart';
import 'package:personal_trainer/Screens/Home/Inicio_Navigate.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return Authenticate();
          }          
          return MultiProvider(
              providers:[
                StreamProvider<UserProfile>.value(value: DatabaseService().userData),         
                StreamProvider<ProgressPictureList>.value(value: DatabaseService().progressPictures),
                ///Chat List Provider
                StreamProvider<List<ChatsList>>.value(value: DatabaseService().chatsList),
                ///Group Notifications Provider
                StreamProvider<GroupNotificationList>.value(value: DatabaseService().groupNotifications),
              ],
            child: InicioNew());
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Loading(),
            ),
          );
        }
      },
    );
      
  }
}