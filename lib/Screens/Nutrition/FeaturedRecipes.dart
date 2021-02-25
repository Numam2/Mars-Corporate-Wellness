import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Models/Recipes.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Nutrition/FeaturedSaved_Container.dart';
import 'package:personal_trainer/Screens/Nutrition/RecipeDetails.dart';
import 'package:provider/provider.dart';

class FeaturedRecipes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final _recipe = Provider.of<List<Recipes>>(context);
    final _user = Provider.of<UserProfile>(context);

    if (_recipe == null || _recipe.length == 0) {
      return SizedBox();
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 35,
            width: double.infinity, 
            child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children:<Widget>[
                      Text(
                          "Recetas recomendadas",
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
                                builder: (context) => FeaturedSavedContainer(recipeType: 'recomendadas', user: _user)));
                        }
                      )
                    ] 
                  ),
                ),
          ),
          SizedBox(height: 20),
          Container(
            height: 250,
            child: ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: (_recipe.length > 8) ? 8 : _recipe.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: (index == _recipe.length - 1)
                        ? const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10)
                        : const EdgeInsets.only(
                            left: 20.0, top: 10, bottom: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecipeDetails(
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
                                    )));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            boxShadow: <BoxShadow>[
                              new BoxShadow(
                                color: Colors.grey[350],
                                offset: new Offset(0.0, 3.0),
                                blurRadius: 10.0,
                              )
                            ]),
                        child: Column(children: [
                          //Image
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(_recipe[index].image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          //Text
                          Container(
                            height: 75,
                            width: double.infinity,
                            padding: EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              //Name and + Time
                              Row(children: [
                                //Name
                                Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.45),
                                  child: Text(_recipe[index].name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14)),
                                ),
                                Spacer(),
                                //Time
                                Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.2),
                                  child: Text(_recipe[index].time,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          Theme.of(context).textTheme.display2),
                                ),
                              ]),
                              SizedBox(height: 10),
                              //Tag
                              Container(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.2),
                                child: Text(_recipe[index].category,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.display2),
                              ),
                            ]),
                          ),
                        ]),
                      ),
                    ),
                  );
                }),
          ),
        ]);
  }
}
