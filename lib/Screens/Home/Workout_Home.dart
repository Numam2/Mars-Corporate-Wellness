import 'package:flutter/material.dart';
import 'package:personal_trainer/Screens/Free_Workouts/Free_Routines.dart';
import 'package:personal_trainer/Screens/Free_Workouts/Individual_Workouts.dart';
import 'package:personal_trainer/Screens/Workouts/WorkoutView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:progress_indicators/progress_indicators.dart';

class WorkoutsHome extends StatefulWidget {
  @override
  _WorkoutsHomeState createState() => _WorkoutsHomeState();
}

class _WorkoutsHomeState extends State<WorkoutsHome> {
  Future getFreeRoutines() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection("Free Routines")
        .getDocuments(); //'dsYJLfLsvGgMVEfWe18RnNa2VuX2'
    return qn.documents;
  }

    Future getIndividualWorkouts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection("Individual Workouts")
        .getDocuments(); //'dsYJLfLsvGgMVEfWe18RnNa2VuX2'
    return qn.documents;
  }

  /////// Create a function to navigate into further details for every document printed
  navigatetoDetail(String freeRoutine){
    Navigator.push(context, MaterialPageRoute(builder: (context) => FreeRoutineView(freeRoutine: freeRoutine)));
  }

  /////// Create a function to navigate into individual workouts
  navigatetoWorkout(String individualWorkout){
    Navigator.push(context, MaterialPageRoute(builder: (context) => IndividualWorkoutView(individualWorkout: individualWorkout)));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          //color: Colors.blueGrey.shade900,
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
                        style: TextStyle(
                            fontSize: 25.0,
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.bold,
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
                    style: TextStyle(
                        fontSize: 25.0,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),

              SizedBox(height: 10),

              Container(
                height: 160,
                child: 
                FutureBuilder(
                  future: getFreeRoutines(),
                  builder: (context,snapshot){

                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(
                      child: JumpingDotsProgressIndicator(
                        fontSize: 20.0,
                      ),
                    );

                  } else {

                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (_, index) {

                        return Padding(
                            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                            child: InkWell(
                                onTap: () => navigatetoDetail(snapshot.data[index].data["Name"]),
                                child: Container(
                                height: 150,
                                width: 190,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: <BoxShadow> [
                                          new BoxShadow(
                                            color: Colors.black12,
                                            offset: new Offset(5.0, 5.0),
                                            blurRadius: 5.0,
                                            spreadRadius: 0
                                            )
                                          ]
                                  ),
                                margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
                                child: Column(                                  
                                  children: <Widget>[
                                    ///Image
                                    Container(
                                      height: 100,
                                      width: double.infinity,
                                       decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(snapshot.data[index].data["Image"]),
                                          fit: BoxFit.cover,                              
                                          ),
                                       ),
                                    ),
                                    ///Text                 
                                    Container(
                                      width: double.infinity,                                      
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(top: 12.0, left: 8.0),
                                            child: Text(
                                              snapshot.data[index].data["Name"],
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),

                                          Spacer(),

                                          Padding(
                                            padding: const EdgeInsets.only(top: 12.0, right: 8.0),
                                            child: Text(
                                              snapshot.data[index].data["Duration"],
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Colors.black45,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          
                                        ]
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ));
                      });
                    } /// End else
                  }
                ),
              ),

              Container(
                padding: EdgeInsets.fromLTRB(20.0, 25.0, 10.0, 10.0),
                width: double.infinity,
                //color: Colors.blue,
                child: Text("Explore Workouts",
                    style: TextStyle(
                        fontSize: 25.0,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),

              SizedBox(height: 10),

             Container(
                height: 160,
                child: 
                FutureBuilder(
                  future: getIndividualWorkouts(),
                  builder: (context,snapshot){
                  
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(
                      child: JumpingDotsProgressIndicator(
                        fontSize: 20.0,
                      ),
                    );

                  } else {

                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (_, index) {

                        return Padding(
                            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                            child: InkWell(
                                onTap: () => navigatetoWorkout(snapshot.data[index].data["Name"]),
                                child: Container(
                                height: 150,
                                width: 190,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: <BoxShadow> [
                                          new BoxShadow(
                                            color: Colors.black12,
                                            offset: new Offset(5.0, 5.0),
                                            blurRadius: 5.0,
                                            spreadRadius: 0
                                            )
                                          ]
                                  ),
                                margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
                                child: Column(                                  
                                  children: <Widget>[
                                    ///Image
                                    Container(
                                      height: 100,
                                      width: double.infinity,
                                       decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(snapshot.data[index].data["Image"]),
                                          fit: BoxFit.cover,                              
                                          ),
                                       ),
                                    ),
                                    ///Text                 
                                    Container(
                                      width: double.infinity,                                      
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(top: 12.0, left: 8.0),
                                            child: Text(
                                              snapshot.data[index].data["Name"],
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),

                                          Spacer(),

                                          Padding(
                                            padding: const EdgeInsets.only(top: 12.0, right: 8.0),
                                            child: Text(
                                              snapshot.data[index].data["Duration"],
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Colors.black45,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          
                                        ]
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ));
                      });
                    } /// End else
                  }
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
