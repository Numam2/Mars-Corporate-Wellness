import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Models/Recipes.dart';
import 'package:personal_trainer/Models/userProfile.dart';
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
      children:<Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children:<Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Recetas de la semana",
                style: Theme.of(context).textTheme.title,
                  textAlign: TextAlign.start,
              ),
            ),
          ] 
        ),
        SizedBox(height: 20),
        Container(
          height: 175,
          child: ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: _recipe.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:(index == _recipe.length -1) ? const EdgeInsets.symmetric(horizontal: 20.0): const EdgeInsets.only(left: 20.0),
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
                        height: 100,
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.grey[250],
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                                image: NetworkImage(_recipe[index].image),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.black38, BlendMode.darken)),
                            boxShadow: <BoxShadow>[
                              new BoxShadow(
                                color: Colors.white,
                                offset: new Offset(0.0, 3.0),
                                blurRadius: 5.0,
                              )
                            ]),
                        child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                                child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(_recipe[index].name,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16)),
                            )))),
                  ),
                );
              }),
        ),
      ]
    );
  }
}
