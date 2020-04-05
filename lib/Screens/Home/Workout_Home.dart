import 'package:flutter/material.dart';
import 'package:personal_trainer/Models/explore.dart';
import 'package:personal_trainer/Screens/Free_Workouts/FreeRoutinesList.dart';
import 'package:personal_trainer/Screens/Free_Workouts/IndividualWorkoutsList.dart';
import 'package:personal_trainer/Screens/Workouts/WorkoutView.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:provider/provider.dart';

class WorkoutsHome extends StatelessWidget {

  @override  
  Widget build(BuildContext context) {

  final _routine = Provider.of<List<ExploreRoutines>>(context);
  final _workout = Provider.of<List<ExploreWorkouts>>(context);

  if (_routine == null && _workout == null){
    return Center(
      child: Loading()
    );
  }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WorkoutView()));
                },
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                      image: AssetImage('Images/AppImage1.jpg'),
                      fit: BoxFit.cover,
                      )
                  ),
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(30.0, 150.0, 60.0, 10.0),
                      child: Text(
                        "My Personal Plan",
                        style: GoogleFonts.montserrat(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                        textAlign: TextAlign.start,
                      )),
                ),
              ),

              Container(
                padding: EdgeInsets.fromLTRB(20.0, 25.0, 10.0, 10.0),
                width: double.infinity,
                //color: Colors.blue,
                child: Text("Recommended Routines",
                    style: GoogleFonts.montserrat(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black)),
              ),

              SizedBox(height: 10),

              Container(
                height: 160,
                child: FreeRoutinesList(),
              ),

              Container(
                padding: EdgeInsets.fromLTRB(20.0, 25.0, 10.0, 10.0),
                width: double.infinity,
                //color: Colors.blue,
                child: Text("Explore Workouts",
                    style: GoogleFonts.montserrat(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black)),
              ),

              SizedBox(height: 10),

             Container(
                height: 160,
                child: IndividualWorkoutsList(),               
              ),

            ],
          ),
        ),
      ),
    );
  }
}
