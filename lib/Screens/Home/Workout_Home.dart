import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/explore.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Free_Workouts/AllRecommended.dart';
import 'package:personal_trainer/Screens/Free_Workouts/AllRoutines.dart';
import 'package:personal_trainer/Screens/Free_Workouts/AllWorkouts.dart';
import 'package:personal_trainer/Screens/Free_Workouts/FreeRoutinesList.dart';
import 'package:personal_trainer/Screens/Free_Workouts/IndividualWorkoutsList.dart';
import 'package:provider/provider.dart';

class WorkoutsHome extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserProfile>(context);
    
    return MultiProvider(
      providers: [        
        StreamProvider<List<ExploreRoutines>>.value(value: DatabaseService().freeRoutinesList(user.goals, user.experience)),
      ],
          child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                
                //Free Routines Carousel
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: <Widget>[
                        Text("Rutinas recomendadas",
                            style: Theme.of(context).textTheme.title),
                        Spacer(),
                        IconButton(
                          onPressed:  () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AllRoutines()));
                        },
                          icon: Icon(Icons.add, color: Theme.of(context).primaryColor, size: 30)
                      )]
                    )),
                ),
                Container(
                  height: 250,
                  child: FreeRoutinesList(),
                ),

                ///Category Selection
                Container(
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 10.0, 10.0),
                  width: double.infinity,
                  //color: Colors.blue,
                  child: Text("Categorías",
                      style: Theme.of(context).textTheme.title),
                ),
                SizedBox(height: 10),
                //Button Category selection
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width * 0.2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Workout
                        InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AllWorkouts(selectedCategory: 'En casa')));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:[
                              //Button
                              Container(
                                width: MediaQuery.of(context).size.width * 0.12,
                                height: MediaQuery.of(context).size.width * 0.12,
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.white,
                                image: DecorationImage(
                                  image: AssetImage(
                                      'Images/App Pics/iconos_01 entrena.png'),
                                  fit: BoxFit.fitWidth),
                                boxShadow: <BoxShadow>[
                                  new BoxShadow(
                                    color: Colors.grey[200],
                                    offset: new Offset(0.0, 3.0),
                                    blurRadius: 2.0,
                                  )
                                ]),
                              ),
                              SizedBox(height: 10),
                              //Text
                              Text('Entrena',
                                style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                              ),
                            ] 
                          ),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                        //Yoga
                        InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AllWorkouts(selectedCategory: 'Yoga')));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:[
                              //Button
                              Container(
                                width: MediaQuery.of(context).size.width * 0.12,
                                height: MediaQuery.of(context).size.width * 0.12,
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.white,
                                image: DecorationImage(
                                  image: AssetImage(
                                      'Images/App Pics/iconos-02 yoga.png'),
                                  fit: BoxFit.fitWidth
                                ),
                                boxShadow: <BoxShadow>[
                                  new BoxShadow(
                                    color: Colors.grey[200],
                                    offset: new Offset(0.0, 3.0),
                                    blurRadius: 2.0,
                                  )
                                ])),
                              SizedBox(height: 10),
                              //Text
                              Text('Yoga',
                                style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                              ),
                            ] 
                          ),
                        ),                                           
                        SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                        //Stretching
                        InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AllWorkouts(selectedCategory: 'Stretching')));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:[
                              //Button
                              Container(
                                width: MediaQuery.of(context).size.width * 0.12,
                                height: MediaQuery.of(context).size.width * 0.12,
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.white,
                                image: DecorationImage(
                                  image: AssetImage(
                                      'Images/App Pics/iconos-03 stretching.png'),
                                  fit: BoxFit.fitWidth
                                ),
                                boxShadow: <BoxShadow>[
                                  new BoxShadow(
                                    color: Colors.grey[200],
                                    offset: new Offset(0.0, 3.0),
                                    blurRadius: 2.0,
                                  )
                                ])),
                              SizedBox(height: 10),
                              //Text
                              Text('Stretching',
                                style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                              ),
                            ] 
                          ),
                        ),                                                             
                        SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                        //Meditation
                        InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AllWorkouts(selectedCategory: 'Meditación')));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:[
                              //Button
                              Container(
                                width: MediaQuery.of(context).size.width * 0.12,
                                height: MediaQuery.of(context).size.width * 0.12,
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.white,
                                image: DecorationImage(
                                  image: AssetImage(
                                      'Images/App Pics/iconos-04 mente.png'),
                                  fit: BoxFit.fitWidth
                                ),
                                boxShadow: <BoxShadow>[
                                  new BoxShadow(
                                    color: Colors.grey[200],
                                    offset: new Offset(0.0, 3.0),
                                    blurRadius: 2.0,
                                  )
                                ])),
                              SizedBox(height: 10),
                              //Text
                              Text('Mente',
                                style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                              ),
                            ] 
                          ),
                        ),                                                                                                      

                    ],),
                  ),
                ),

                ///Recommended
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: <Widget>[
                        Text("Recomendados",
                            style: Theme.of(context).textTheme.title),
                        Spacer(),
                        IconButton(
                          onPressed:  () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        StreamProvider<List<ExploreWorkouts>>.value(
                                          value: DatabaseService().freeWorkoutsList('En casa', user.goals),
                                          child: AllRecommended())));
                        },
                          icon: Icon(Icons.add, color: Theme.of(context).primaryColor, size: 30)
                      )]
                    )),
                ),
                SizedBox(height: 10),
                Container(
                  height: 160,
                  child: StreamProvider<List<ExploreWorkouts>>.value(
                    value: DatabaseService().freeWorkoutsList('En casa', user.goals),
                    child: IndividualWorkoutsList()),               
                ),
                SizedBox(height: 10),

                //Mindfullness
                Padding(      
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => HirePersonalizedRoutine(myUserProfile: _user)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                                image: AssetImage(
                                    'Images/App Pics/iconos ilust-17.png'),
                                fit: BoxFit.cover,
                                colorFilter:
                                    ColorFilter.mode(Colors.black38, BlendMode.darken)),
                            boxShadow: <BoxShadow>[
                              new BoxShadow(
                                color: Colors.grey,
                                offset: new Offset(0.0, 3.0),
                                blurRadius: 5.0,
                              )
                            ]),
                        child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ///Text
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Entrena tu',
                                        style: GoogleFonts.montserrat(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        'mente',
                                        style: Theme.of(context).textTheme.caption,
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  )
                                ])),
                      ),
                    ),
                  ),
                ),
                
                ///Workout: 15 minutes
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: <Widget>[
                        Text("15 minutos o menos",
                            style: Theme.of(context).textTheme.title),
                        Spacer(),
                        IconButton(
                          onPressed:  () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AllWorkouts(selectedCategory: 'Cortos')));
                        },
                          icon: Icon(Icons.add, color: Theme.of(context).primaryColor, size: 30)
                      )]
                    )),
                ),
                SizedBox(height: 10),
                Container(
                  height: 160,
                  child: StreamProvider<List<ExploreWorkouts>>.value(
                    value: DatabaseService().freeWorkoutsList('Cortos', user.goals),
                    child: IndividualWorkoutsList()),               
                ),


              ],
            ),
          ),
        ),
    );
  }
}
