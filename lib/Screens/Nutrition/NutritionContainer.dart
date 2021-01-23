import 'package:flutter/material.dart';
import 'package:personal_trainer/Screens/Nutrition/NutritionHome.dart';

class NutritionContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(        
          backgroundColor: Colors.white,          
          centerTitle: true,
          title: Text('Recetas',
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
        body: NutritionHome()
      )
    );
  }
}