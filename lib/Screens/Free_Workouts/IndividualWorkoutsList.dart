import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Models/explore.dart';
import 'package:personal_trainer/Screens/Free_Workouts/IndividualWorkoutIntro.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:provider/provider.dart';

class IndividualWorkoutsList extends StatelessWidget {
  navigatetoWorkout(context, String individualWorkout, String routineImage, String author, String routineTime, String description, List objectives, List equipment) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => IndividualWorkoutIntro(freeRoutine: individualWorkout, routineImage: routineImage, author: author, routineTime: routineTime, description: description, objective: objectives, equipment: equipment)));
  }

  @override
  Widget build(BuildContext context) {
    
    final _workout = Provider.of<List<ExploreWorkouts>>(context);

    if(_workout == null){
      return ListView.builder(
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, index) {
          return Padding(
              padding: (index == 0) 
                ? EdgeInsets.fromLTRB(20, 5, 10, 5)
                : EdgeInsets.fromLTRB(0, 5, 10, 5),
              child: InkWell(
                child: Container(
                  height: 150,
                  width: 150,
                  margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
                  child: Column(
                    children: <Widget>[
                      ///Image
                      Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8.0),                         
                        ),
                      ),

                      ///Text
                      Container(
                        width: double.infinity,
                        child: Row(children: <Widget>[
                          Padding(
                            padding:const EdgeInsets.only(top: 12.0),
                            child: Container(
                              width: 85,
                              height: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25)),
                                  color: Colors.grey[200],
                                ),
                              ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Container(
                              width: 30,
                              height: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25)),
                                  color: Colors.grey[200],
                                ),
                              ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ));
        });
    }

      return ListView.builder(
        itemCount: _workout.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, index) {
          return Padding(
              padding: (index == 0) 
                ? EdgeInsets.fromLTRB(20, 5, 10, 5)
                : EdgeInsets.fromLTRB(0, 5, 10, 5),
              child: InkWell(
                onTap: () => navigatetoWorkout(context, 
                  _workout[index].name,
                  _workout[index].image,
                  _workout[index].author,
                  _workout[index].duration, 
                  _workout[index].description, 
                  _workout[index].objectives, 
                  _workout[index].equipment
                ),
                child: Container(
                  height: 150,
                  width: 150,
                  margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
                  child: Column(
                    children: <Widget>[
                      ///Image
                      Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: NetworkImage(_workout[index].image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      ///Text
                      Container(
                        width: double.infinity,
                        child: Row(children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 12.0),
                            child: Container(
                              constraints: BoxConstraints(maxWidth: 105),
                              child: Text(
                                _workout[index].name,
                                textAlign: TextAlign.start,
                                style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 12.0),
                            child: Text(
                              _workout[index].duration,
                              textAlign: TextAlign.start,
                              style: GoogleFonts.montserrat(
                                color: Colors.black45,
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ));
        });
  }
}
