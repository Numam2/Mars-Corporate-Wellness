import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Models/workout.dart';
import 'package:personal_trainer/Screens/Workouts/WorkoutPageView.dart';
import 'package:personal_trainer/Screens/wrapper.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatelessWidget {

  final String day;
  final List exerciseVideoList;
  final PageController pageController;
  WorkoutPage({this.day, this.exerciseVideoList, this.pageController});

  @override
  Widget build(BuildContext context) {

    final workout = Provider.of<List<Workout>>(context);

    if (workout == null || workout.length == null || workout.length == 0){
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Empty Workout Illustration
            Container(
              width: MediaQuery.of(context).size.width *0.7,
              child: Image(
                image: NetworkImage(
                  'https://firebasestorage.googleapis.com/v0/b/ludus-health-coach.appspot.com/o/App%20Images%2FEmptyWorkout_undraw.png?alt=media&token=d160dc10-959f-4e0e-b3ee-f1d8e4b22c74')),
                ),
            SizedBox(height: 20),
            //Text
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width*0.7
              ),
              child: Text(
                "Oops.. Este entrenamiento aún no está disponible",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            ///Button
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 35.0,
                      child: RaisedButton(
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Wrapper())),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).accentColor,
                                Theme.of(context).primaryColor
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 200.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              "VOLVER",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
          ],
        );
    }    

    return WorkoutPageView(workout: workout, exerciseVideoList: exerciseVideoList, day: day, pageController: pageController);
  }
}



















// class _WorkoutPageState extends State<WorkoutPage> {

//   String currentExercise;
//   String currentExcReps;
//   String currentExcDuration;
//   List<Exercise> exerciseList = [];

//   // final controller = PageController(initialPage:0);
//   // final int totalPages = 4;
  
//   int currentpage = 0;

//   @override
//   Widget build(BuildContext context) {

//     final workout = Provider.of<List<Workout>>(context);

//     if (workout == null){
//       return Center(
//         child: Loading()
//       );
//     }

//     for (int i=0; i<workout.length; i++) {
//       for (int n=0; n < workout[i].rounds; n++){
//         workout[i].sets.forEach(
//           (x) => exerciseList.add(x));
//       }
//     }

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children:<Widget> [
//         ///Heading
//         Padding(
//           padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: <Widget>[
//               //Go back
//               InkWell(
//                 onTap: (){
//                   Navigator.of(context).pop();
//                 },
//                 child: Container(
//                   height: MediaQuery.of(context).size.width*0.1,
//                   width: MediaQuery.of(context).size.width*0.1,
//                   child: Center(child: Icon(Icons.keyboard_arrow_left, color: Colors.black))),
//               ),
//               Spacer(),
//               //Title
//               Text(widget.day,
//                 style: Theme.of(context).textTheme.headline),
//               Spacer(),
//               //Start
//               Container(
//                 height: MediaQuery.of(context).size.width*0.1,
//                 width: MediaQuery.of(context).size.width*0.1,
//                 child: InkWell(
//                   onTap: (){},
//                   child: Center(child: Icon(Icons.play_arrow, color: Colors.black))
//                 ),
//               ),
//             ],
//           ),
//         ),
//         ///Sets
//         Flexible(
//           fit: FlexFit.loose,
//           child: Container(
//             child: ListView.builder(
//               itemCount: workout.length,
//               physics: BouncingScrollPhysics(),
//               itemBuilder: (context, index){

//                 return Padding(
//                   padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 8.0),
//                   child: 
                    
//                     Column(                
//                       children:<Widget>[

//                         ///// Display title of set
//                         Padding(
//                         padding: const EdgeInsets.fromLTRB(15.0, 8.0, 40.0, 8.0),
//                         child: 
//                           Row(
//                             children: <Widget>[
//                               Text(workout[index].stage,
//                                 style: Theme.of(context).textTheme.title
//                               ),
//                               Spacer(),
//                               Text('x' + workout[index].rounds.toString(),
//                                 style: GoogleFonts.montserrat(
//                                   fontSize: 16.0, color: Colors.black54),
//                               ),
//                             ],
//                           ),
//                       ),

//                       ///// Nest inside the list of each exercise within sets
//                       ListView.builder(
//                         itemCount: workout[index].sets.length,
//                         shrinkWrap: true,
//                         physics: ClampingScrollPhysics(),
//                         itemBuilder: (context, i){

//                           return StreamProvider<ExerciseDetail>.value(
//                             value: DatabaseService().exerciseDetail(workout[index].sets[i].exerciseName),
//                             child: ExerciseCard(
//                               exerciseName: workout[index].sets[i].exerciseName,
//                               exerciseWeight: workout[index].sets[i].weight,
//                               exerciseReps: workout[index].sets[i].reps,
//                               exerciseDuration: workout[index].sets[i].duration,
//                             ),
//                           );

//                         }
//                       )

//                     ]                
//                   ),              
                      
//                 );
//               }
//             )
//           ),
//         ),
//       ]
//     );
//   }
// }