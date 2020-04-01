//import 'package:flutter/material.dart';
// import 'package:personal_trainer/Firebase_Services/auth.dart';
// import 'package:personal_trainer/Screens/Workouts/WeekDayView.dart';
// import 'package:personal_trainer/Screens/Workouts/WorkoutView.dart';

// class Inicio extends StatelessWidget {

//   final AuthService _auth = AuthService();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
      
//       //Page color
//       resizeToAvoidBottomPadding: false,
//       backgroundColor: Colors.blueGrey.shade900,

//         //App Bat design
//         appBar: AppBar(
//           backgroundColor: Colors.blueGrey.shade900,
//           elevation: 0.0,
//           title: Text("",textAlign: TextAlign.center
//             ),
//           actions: <Widget>[
//               FlatButton.icon(
//                 icon: Icon(
//                   Icons.person,
//                    color: Colors.white,),
//                 label: Text(
//                   "Log out",
//                    style: TextStyle(color: Colors.white)),
//                 onPressed: () async {
//                   await _auth.signOut();
//                 },
//               )
//             ],
//           ),


//         body: Stack(children: <Widget>[

//           //Title of page
//           Container(
//           padding: EdgeInsets.all(20),
          
//           child: Padding(
//             padding: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 20.0),
//             child: Container(
//               child: Column(
//                 children:<Widget>[

//                   Row(
//                     children: <Widget>[
//                       Container(
//                         padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 50.0),
//                         child: Text(
//                               "Welcome back!",
//                               style: TextStyle(
//                                 fontSize: 25.0, fontFamily: "Roboto", fontWeight: FontWeight.bold, color: Colors.white
//                               )
//                             ),
//                       ),
//                     ],
//                   ),
                  

                  
//                 //Navigation button to open Workouts
//                 SizedBox(height: 45),

//                 Row(
//                   children: <Widget>[
//                         Container(
//                           padding: EdgeInsets.only(left: 30),
//                           child: IconButton(
//                                   icon: Icon(Icons.fitness_center), 
//                                   color: Colors.teal,
//                                   iconSize: 70.0,         
//                                     onPressed: () {            
//                                       Navigator.push(context, MaterialPageRoute<void>(
//                                           builder: (BuildContext context) {                
//                                               return  WorkoutView ();             
//                                             },            
//                                         ));          
//                                     }),
//                         ),

//                         Spacer(),

//                          Container(
//                            padding: EdgeInsets.only(right: 30),
//                            child: IconButton(
//                                   icon: Icon(Icons.message), 
//                                   color: Colors.teal,
//                                   iconSize: 70.0,         
//                                     onPressed: () {            
//                                       Navigator.push(context, MaterialPageRoute<void>(
//                                           builder: (BuildContext context) {                
//                                               return  WorkoutView ();             
//                                             },            
//                                         ));          
//                                     }),
//                          ),
//                                 ],
//                           ),

//                          Divider(
//                               color: Colors.grey,
//                               height: 36,
//                             ),

//                 Row(
//                   children: <Widget>[
//                         Container(
//                           padding: EdgeInsets.only(left: 30),
//                           child: IconButton(
//                                   icon: Icon(Icons.track_changes), 
//                                   color: Colors.teal,
//                                   iconSize: 70.0,         
//                                     onPressed: () {            
//                                       Navigator.push(context, MaterialPageRoute<void>(
//                                           builder: (BuildContext context) {                
//                                               return  WeekDay();             
//                                             },            
//                                         ));          
//                                     }),
//                         ),

//                         Spacer(),

//                          Container(
//                            padding: EdgeInsets.only(right: 30),
//                            child: IconButton(
//                                   icon: Icon(Icons.person), 
//                                   color: Colors.teal,
//                                   iconSize: 70.0,
//                                     onPressed: () {
//                                       Navigator.push(context, MaterialPageRoute<void>(
//                                           builder: (BuildContext context) {                
//                                               return  WeekDay();             
//                                             },
//                                         ));
//                                     }),
//                                   ),
//                                 ],
//                           ),

//                 ],
//               ),
//             ),
//           )
//        ),
//     ],)
      
//     );
//   }
// }
                
                
                
                       
                         