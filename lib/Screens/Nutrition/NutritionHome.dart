import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/Recipes.dart';
import 'package:personal_trainer/Screens/Nutrition/RecipesList.dart';
import 'package:provider/provider.dart';

class NutritionHome extends StatefulWidget {

  @override
  _NutritionHomeState createState() => _NutritionHomeState();
}

class _NutritionHomeState extends State<NutritionHome> {

  final List filters = ['Todo', 'Perder peso', 'Ganar músculo', 'Alto en Proteína', 'Bajo en calorías', 'Vegetariano', 'Vegano', 'Apto Celíacos', 'Desayuno', 'Snack'];
  String isSelected = 'Todo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
            children: <Widget>[
              ////Filters List
              Container(
                height: 70,
                child: ListView.builder(
                  itemCount: filters.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index){
                    return Padding(
                      padding: (index == 0)
                      ? const EdgeInsets.fromLTRB(20, 20, 5, 20)
                      : const EdgeInsets.fromLTRB(5, 20, 5, 20),
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            isSelected = filters[index];
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal:15.0),
                          decoration: BoxDecoration(
                            color: (isSelected == filters[index]) ? Theme.of(context).accentColor : Theme.of(context).disabledColor,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(25.0)),
                          child: Center(
                            child: Text(filters[index],
                                style: GoogleFonts.montserrat(fontWeight:FontWeight.w400, fontSize: 12, 
                                color: (isSelected == filters[index]) ? Colors.white : Theme.of(context).canvasColor)
                            ),
                          )
                        ),
                      ),
                    );
                  }
                ),
              ),
              
              ////List of recipes
              StreamProvider<List<Recipes>>.value(
                value: DatabaseService().reipes(isSelected),
                child: RecipesList(),
              )
            
            ],
          ),
      ),
    );
  }
}