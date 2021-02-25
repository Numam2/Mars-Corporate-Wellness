import 'package:flutter/material.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/Recipes.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Nutrition/RecipeDetails.dart';
import 'package:provider/provider.dart';

class RecipesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final _recipe = Provider.of<List<Recipes>>(context);
    final _user = Provider.of<UserProfile>(context);

    if(_recipe == null){

      return Flexible(
        fit: FlexFit.loose,
        child: ListView.builder(
          itemCount: 2,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: <BoxShadow>[
                      new BoxShadow(
                        color: Colors.grey[350],
                        offset: new Offset(0.0, 3.0),
                        blurRadius: 5.0,
                      )
                    ]),
                child: Row(
                  children: <Widget>[
                    ///Image
                    Container(
                      height: double.infinity,
                      width: MediaQuery.of(context).size.width * 0.35,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8.0),
                              topLeft: Radius.circular(8.0)),
                          boxShadow: <BoxShadow>[
                            new BoxShadow(
                              color: Colors.grey[350],
                              offset: new Offset(0.0, 3.0),
                              blurRadius: 5.0,
                            )
                          ]),
                    ),

                    ///Info
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ///Name
                          Container(
                            height: 20,
                            width: MediaQuery.of(context).size.width * 0.45,
                            decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.grey[350],
                            borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                          SizedBox(height: 10),

                          ///Intro
                          Container(
                            height: 15,
                            width: MediaQuery.of(context).size.width * 0.35,
                            decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            height: 15,
                            width: MediaQuery.of(context).size.width * 0.40,
                            decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                          Spacer(),

                          ///Time and Category
                          Container(
                            height: 15,
                            width: MediaQuery.of(context).size.width * 0.30,
                            decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.grey[00],
                            borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
      );
      
    }

    return Flexible(
      fit: FlexFit.loose,
      child: ListView.builder(
          itemCount: _recipe.length,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return FlatButton(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              onPressed: (){
                DatabaseService().recordOrganizationStats(_user.organization, 'Recipe Views');
                Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => 
                    RecipeDetails(
                      userProfile: _user,
                      user: _user.uid,
                      name: _recipe[index].name,
                      description: _recipe[index].intro,
                      author: _recipe[index].author,
                      time: _recipe[index].time,
                      category: _recipe[index].category,
                      image: _recipe[index].image,
                      ingredients: _recipe[index].ingredients,
                      directions: _recipe[index].directions,
                      tags: _recipe[index].tags,
                      recipeID: _recipe[index].recipeID,
                      likes: _recipe[index].likes,
                    )
                  )
                );
              },
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: <BoxShadow>[
                      new BoxShadow(
                        color: Colors.grey[350],
                        offset: new Offset(0.0, 3.0),
                        blurRadius: 5.0,
                      )
                    ]),
                child: Row(
                  children: <Widget>[
                    ///Image
                    Container(
                      height: double.infinity,
                      width: MediaQuery.of(context).size.width * 0.35,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.grey[250],
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8.0),
                              topLeft: Radius.circular(8.0)),
                          image: DecorationImage(
                            image: NetworkImage(_recipe[index].image),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: <BoxShadow>[
                            new BoxShadow(
                              color: Colors.white,
                              offset: new Offset(0.0, 3.0),
                              blurRadius: 5.0,
                            )
                          ]),
                    ),

                    ///Info
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ///Name
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Text(
                              _recipe[index].name,
                              style: Theme.of(context).textTheme.title,
                            ),
                          ),
                          SizedBox(height: 5),

                          ///Intro
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Text(
                              _recipe[index].intro,
                              style: Theme.of(context).textTheme.body1,
                            ),
                          ),
                          Spacer(),

                          ///Time and Category
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Text(
                              _recipe[index].time + ' - ' + _recipe[index].category,
                              style: Theme.of(context).textTheme.display2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
    
  }
}
