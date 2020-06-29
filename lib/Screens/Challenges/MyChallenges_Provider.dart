import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/Recipes.dart';
import 'package:personal_trainer/Models/challenge.dart';
import 'package:personal_trainer/Models/goals.dart';
import 'package:personal_trainer/Models/messages.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Challenges/GoalCreate.dart';
import 'package:personal_trainer/Screens/Challenges/Goal_Select_Type.dart';
import 'package:personal_trainer/Screens/Challenges/GoalsView.dart';
import 'package:personal_trainer/Screens/Challenges/myChallengeList.dart';
import 'package:personal_trainer/Screens/Home/GoToWorkoutRoutine.dart';
import 'package:personal_trainer/Screens/Messages/MessageHome.dart';
import 'package:personal_trainer/Screens/Messages/MessagesStart.dart';
import 'package:personal_trainer/Screens/Nutrition/FeaturedRecipes.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:provider/provider.dart';


class MyChallengesProvider extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    final _challenges = Provider.of<List<Challenge>>(context);
    final _goal = Provider.of<List<Goals>>(context);
    final _chats = Provider.of<List<ChatsList>>(context);
    final _user = Provider.of<UserProfile>(context);

    if (_challenges == null || _goal == null || _user == null){
      return Center(
        child: Loading()
      );
    }

    return Scaffold(
      appBar: AppBar(        
        backgroundColor: Colors.white,          
        centerTitle: true,
        title: Container(
          padding: EdgeInsets.symmetric(horizontal:8),
          height: 90,
          child: Image(image: AssetImage('Images/Brand/Primary Logo Blue.png')),
        ),        
        actions:<Widget>[
          IconButton(
            onPressed:(){

              if (_chats.length == 0) {
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MessagesStart()));
              } else {
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => 
                    StreamProvider<List<ChatsList>>.value(
                      value: DatabaseService().chatsList,
                      child: MessagesHome())));
              }

            },
            icon: Icon(CupertinoIcons.conversation_bubble, color: Colors.black, size:20),
          ),
        ],
      ),

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:<Widget>[
              ///Workout Image
              GoToWorkoutRoutine(),                                           
              ///Daily Challenges
              ChallengeList(),
              ///Goals Text
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children:<Widget>[
                    Text(
                        "Mis metas",
                        style: Theme.of(context).textTheme.title,
                        textAlign: TextAlign.start,
                      ),                    
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.add, color: Theme.of(context).primaryColor, size: 30),
                      onPressed: (){
                         Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GoalSelectType()));
                      }
                    )
                  ] 
                ),
              ),              
              ///Goals
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GoalsView(),
              ),
              SizedBox(height:35),
              ///Recipes of the week              
              StreamProvider<List<Recipes>>.value(
                value: DatabaseService().featuredRecipes,
                child: FeaturedRecipes()
              ),
              SizedBox(height:25),
               
            ]
          ),
        ),
      ),
    );
  }
}