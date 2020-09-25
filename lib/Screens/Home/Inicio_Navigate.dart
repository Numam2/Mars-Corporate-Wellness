import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/challenge.dart';
import 'package:personal_trainer/Models/goals.dart';
import 'package:personal_trainer/Models/groups.dart';
import 'package:personal_trainer/Models/messages.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Challenges/MyChallenges_Provider.dart';
import 'package:personal_trainer/Screens/Home/Explore.dart';
import 'package:personal_trainer/Screens/Profile/Onboarding.dart';
import 'package:personal_trainer/Screens/Profile/Profile.dart';
import 'package:personal_trainer/Screens/Social/MyGroups.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:provider/provider.dart';

class InicioNew extends StatefulWidget {

  @override
  _InicioNewState createState() => _InicioNewState();
}

class _InicioNewState extends State<InicioNew> {

  int pageIndex = 0;

  final tabs = [
    MyChallengesProvider(),
    Explore(),
    MyGroups(),
    ProfilePage(),
  ];


  @override
  Widget build(BuildContext context) {

    final userProfile = Provider.of<UserProfile>(context);

    if (userProfile == null){
      return Loading();
    } else if (userProfile.goal == "None" || userProfile.sex == 'Sex'){
      return Onboarding();
    }

    return WillPopScope(
      onWillPop: () => SystemNavigator.pop(),
      child: MultiProvider(
        providers: [          
          ///Challenges Providers
          StreamProvider<List<Challenge>>.value(value: DatabaseService().challengeList),
          StreamProvider<List<PopularChallenges>>.value(value: DatabaseService().popularChallengeList),
          ///Goals Provider
          StreamProvider<List<Goals>>.value(value: DatabaseService().goalList),
          ///Social Groups Provider
          StreamProvider<List<Groups>>.value(value: DatabaseService().myGroupList),
          ///Chat List
          StreamProvider<List<ChatsList>>.value(value: DatabaseService().chatsList),
        ],
        child: Scaffold(
          
          //Page color
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.white,

            body: Container(
              child: tabs[pageIndex]
              //child: _showPage,
            ),

            bottomNavigationBar: Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.8),            
              ),
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.today, size: 18, color: pageIndex == 0 ? Colors.black : Colors.grey), 
                    onPressed: () {setState((){pageIndex = 0;});}
                  ),
                  IconButton(
                    icon: Icon(Icons.explore, size: 18, color: pageIndex == 1 ? Colors.black : Colors.grey), 
                    onPressed: ()  {setState((){pageIndex = 1;});}
                  ),
                  IconButton(
                    icon: pageIndex == 2 ? Icon(Icons.people, size: 18, color: Colors.black): Icon(Icons.people_outline, size: 18, color: Colors.grey), 
                    onPressed: ()  {setState((){pageIndex =  2;});}
                  ),
                  IconButton(
                    icon: pageIndex == 3 ? Icon(Icons.person, size: 18, color: Colors.black): Icon(Icons.person_outline, size: 18, color: Colors.grey),
                    onPressed: ()  {setState((){pageIndex = 3;});}
                  ),
                ],
              ),
            ),
           
        ),
      ),
    );
  }
}
                
                
                
                       
                         