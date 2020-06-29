import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Models/workout.dart';
import 'package:personal_trainer/Screens/Workouts/ExercisePage.dart';
import 'package:personal_trainer/Screens/Workouts/Exercise_Feedback.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:provider/provider.dart';

class WorkoutSets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final workout = Provider.of<List<Workout>>(context);

    if (workout == null){
      return Center(
        child: Loading()
      );
    }

    return Container(
      child: ListView.builder(
        itemCount: workout.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index){

          return Padding(
            padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 8.0),
            child: 
              
              Column(                
                children:<Widget>[

                  ///// Display title of set
                  Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 8.0, 40.0, 8.0),
                  child: 
                    Row(
                      children: <Widget>[
                        Text(workout[index].stage,
                          style: Theme.of(context).textTheme.title
                        ),
                        Spacer(),
                        Text('x' + workout[index].rounds.toString(),
                          style: GoogleFonts.montserrat(
                            fontSize: 16.0, color: Colors.black54),
                        ),
                      ],
                    ),
                 ),

                 ///// Nest inside the list of each exercise within sets
                ListView.builder(
                  itemCount: workout[index].sets.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, i){
                    
                    if (workout[index].sets[i].weight == "" || workout[index].sets[i].weight == null){

                      return Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: 
                          //////// Card design for each exercise
                          InkWell(
                          onTap: (){
                            Navigator.push(context, 
                                MaterialPageRoute(builder: (context) => ExercisePage(exerciseName: workout[index].sets[i].exerciseName)));
                            },
                          onLongPress: (){
                            showDialog(                                                  
                              context: context,
                              builder: (context){
                                  return ExerciseFeedback(exercise:workout[index].sets[i].exerciseName);
                                  }
                                );                        
                              },  
                              child: Container( 
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: <BoxShadow> [
                                      new BoxShadow(
                                        color: Colors.black12,
                                        offset: new Offset(0.0, 1.0),
                                        blurRadius: 3.0,
                                      )
                                    ]
                                  ),
                                child:
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(25.0, 10.0, 40.0, 10.0),
                                    child:  
                                      Row(children: <Widget>[

                                        Text(workout[index].sets[i].exerciseName,
                                          style: GoogleFonts.montserrat(
                                          fontSize: 12.0, color: Colors.black,
                                          ),
                                        ),
                                        
                                        Spacer(),
                                        
                                        Text(workout[index].sets[i].reps,
                                          style: GoogleFonts.montserrat(
                                            fontSize: 12.0, color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          ),
                      );
                      
                      
                    } else {

                      return Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: 
                          //////// Card design for each exercise
                          InkWell(
                          onTap: (){
                            Navigator.push(context, 
                                MaterialPageRoute(builder: (context) => ExercisePage(exerciseName: workout[index].sets[i].exerciseName)));                            
                            },
                          onLongPress: (){
                            showDialog(                                                  
                              context: context,
                              builder: (context){
                                String exercise = workout[index].sets[i].exerciseName;
                                  print(exercise);
                                  return ExerciseFeedback(exercise:exercise);
                                  }
                                );                        
                              },  
                              child: Container( 
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: <BoxShadow> [
                                      new BoxShadow(
                                        color: Colors.black12,
                                        offset: new Offset(0.0, 1.0),
                                        blurRadius: 3.0,
                                      )
                                    ]
                                  ),
                                child:
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(25.0, 10.0, 40.0, 10.0),
                                    child:  
                                      Row(children: <Widget>[

                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children:<Widget>[

                                            Text(workout[index].sets[i].exerciseName,
                                              style: GoogleFonts.montserrat(
                                              fontSize: 12.0, color: Colors.black,
                                              ),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 5.0),
                                              child: 
                                              Text(workout[index].sets[i].weight,
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 10.0, fontWeight: FontWeight.w200, color: Theme.of(context).canvasColor,
                                                ),
                                              ),
                                            ),

                                          ] 
                                        ),
                                        
                                        Spacer(),
                                        
                                        Text(workout[index].sets[i].reps,
                                          style: GoogleFonts.montserrat(
                                            fontSize: 12.0, color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          ),
                      );

                    }

                  }
                )

                ]                
              ),              
                
          );
        }
      )
    );
  }
}