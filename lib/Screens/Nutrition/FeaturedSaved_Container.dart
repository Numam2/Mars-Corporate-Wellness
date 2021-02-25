import 'package:flutter/material.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/Recipes.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Nutrition/FeaturedRecipesList.dart';
import 'package:personal_trainer/Screens/Nutrition/RecipesList.dart';
import 'package:provider/provider.dart';

class FeaturedSavedContainer extends StatelessWidget {

final String recipeType;
final UserProfile user;

FeaturedSavedContainer({this.recipeType, this.user});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(        
          backgroundColor: Colors.white,          
          centerTitle: true,
          title: Text('Recetas $recipeType',
            style: Theme.of(context).textTheme.headline), 
            leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black,
            ),
          ),
        ),
        body: (recipeType == 'guardadas')
         ? Container(
           child: StreamProvider<List<Recipes>>.value(
              value: DatabaseService().savedRecipes(),
              child: FeaturedRecipesList(),
            )
          )
         : Container(
           child: StreamProvider<List<Recipes>>.value(
              value: DatabaseService().recommendedRecipes(user.goals),
              child: FeaturedRecipesList(),
            )
         )
      )
    );
  }
}