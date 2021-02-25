import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/explore.dart';
import 'package:personal_trainer/Screens/Free_Workouts/AllWorkoutsList.dart';
import 'package:provider/provider.dart';

class AllWorkouts extends StatefulWidget {

  final String selectedCategory;
  AllWorkouts({this.selectedCategory});

  @override
  _AllWorkoutsState createState() => _AllWorkoutsState();
}

class _AllWorkoutsState extends State<AllWorkouts> {
  
  final List categoriesList = ['En casa', 'Cortos', 'Yoga', 'Stretching', 'Meditación'];
  String isSelected;

  @override
  void initState() {
    isSelected = widget.selectedCategory;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(        
          backgroundColor: Colors.white,          
          centerTitle: true,
          title: Text('Sesiones',
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
        body: Container(
          child: Column(
            children: <Widget>[
              ////Filters List
              Container(
                height: 70,
                child: ListView.builder(
                  itemCount: categoriesList.length,
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
                            isSelected = categoriesList[index];
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal:15.0),
                          decoration: BoxDecoration(
                            color: (isSelected == categoriesList[index]) ? Theme.of(context).accentColor : Theme.of(context).disabledColor,

                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(25.0)),
                          child: Center(
                            child: Text(categoriesList[index],
                                style: GoogleFonts.montserrat(fontWeight:FontWeight.w400, fontSize: 12, 
                                color: (isSelected == categoriesList[index]) ? Colors.white : Theme.of(context).canvasColor)
                            ),
                          )
                        ),
                      ),
                    );
                  }
                ),
              ),              
              ////List of recipes
              StreamProvider<List<ExploreWorkouts>>.value(
                  value: DatabaseService().allWorkoutsList(isSelected),
                  child: AllWorkoutsList()),           
            
            ],
          ),
        ),
      )
    );
  }
}