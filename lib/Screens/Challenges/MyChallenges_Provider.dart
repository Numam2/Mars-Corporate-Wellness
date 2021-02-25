import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/Recipes.dart';
import 'package:personal_trainer/Models/challenge.dart';
import 'package:personal_trainer/Models/goals.dart';
import 'package:personal_trainer/Models/posts.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Challenges/Goal_Select_Type.dart';
import 'package:personal_trainer/Screens/Challenges/GoalsView.dart';
import 'package:personal_trainer/Screens/Challenges/OrganizationChallengeList.dart';
import 'package:personal_trainer/Screens/Challenges/myChallengeList.dart';
import 'package:personal_trainer/Screens/Home/ArticlesList.dart';
import 'package:personal_trainer/Screens/Home/GoToWorkoutRoutine.dart';
import 'package:personal_trainer/Screens/Nutrition/FeaturedRecipes.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:provider/provider.dart';


class MyChallengesProvider extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    final _challenges = Provider.of<List<Challenge>>(context);
    final _goal = Provider.of<List<Goals>>(context);
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
      ),

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:<Widget>[
              ///Articles Card
              ArticlesList(),
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
                              builder: (context) => GoalSelectType(userProfile: _user)));
                      }
                    )
                  ] 
                ),
              ),              
              ///Goals
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GoalsView(user: _user),
              ),
              SizedBox(height:25),
              ///Organization Challenges
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children:<Widget>[
                    Text(
                        "Retos en ${_user.organization}",
                        style: Theme.of(context).textTheme.title,
                        textAlign: TextAlign.start,
                      ),                    
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.add, color: Theme.of(context).primaryColor, size: 30),
                      onPressed: (){}
                    )
                  ] 
                ),
              ),             
              OrganizationChallengeList(),
              SizedBox(height:25),
              ///Recipes of the week              
              FeaturedRecipes(),
              SizedBox(height:25),
               
            ]
          ),
        ),
      ),
    );
  }
}