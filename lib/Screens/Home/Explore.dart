import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Screens/Home/Workout_Home.dart';
import 'package:personal_trainer/Screens/Nutrition/NutritionHome.dart';

class Explore extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(        
          backgroundColor: Colors.white,          
          centerTitle: true,
          title: Text('Explora',
            style: Theme.of(context).textTheme.headline),
          leading: Container(
            padding: EdgeInsets.symmetric(horizontal:8),
            height: 10,
            child: Image(image: AssetImage('Images/Brand/Blue Isologo.png'), height: 10),
          ),
          bottom: TabBar(         
            tabs: <Widget>[
              Tab(child: Text('Entrenamiento',
                  style: GoogleFonts.montserrat(
                    color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400
                  )),
              ),
              Tab(child: Text('Nutrición',
                  style: GoogleFonts.montserrat(
                    color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400
                  )),
              ),
            ]
          ),
        ),
        
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            WorkoutsHome(),
            NutritionHome()
          ]
        ),
        
        // Container(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: <Widget>[
        //       //Exercise
        //       Expanded(
        //         child: GestureDetector(
        //           onTap: (){
        //             print('Exercise');
        //             Navigator.push(context,
        //                   MaterialPageRoute(builder: (context) => WorkoutsHome()));
        //           },
        //           child: Container(
        //             //height: MediaQuery.of(context).size.height*0.4,
        //             width: double.infinity,
        //             decoration: BoxDecoration(
        //                 shape: BoxShape.rectangle,
        //                 color: Colors.white,
        //                 image: DecorationImage(
        //                   image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/ludus-health-coach.appspot.com/o/App%20Images%2FExercise.jpg?alt=media&token=27b98dd5-6638-4cac-828e-fad47725c99a'),
        //                   fit: BoxFit.cover,
        //                   colorFilter: ColorFilter.mode(Colors.black45, BlendMode.hue)
        //                 ),
        //             ),
        //             child: Padding(
        //               padding: EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 10.0),
        //               child: Text(
        //                 "Ejercicio",
        //                 style: Theme.of(context).textTheme.caption,
        //                 textAlign: TextAlign.start,
        //               )),
        //           ),
        //         ),
        //       ),

              // //Yoga
              // GestureDetector(
              //   onTap: (){
              //     print('Yoga');
              //   },
              //   child: Padding(
              //     padding: const EdgeInsets.only(bottom: 15.0),
              //     child: Container(
              //       height: 150,
              //       width: double.infinity,
              //       decoration: BoxDecoration(
              //           shape: BoxShape.rectangle,
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(8.0),
              //           image: DecorationImage(
              //             image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/ludus-health-coach.appspot.com/o/App%20Images%2FYoga.jpg?alt=media&token=2d8dfbd1-36ce-4360-ac5a-b3766d47ca62'),
              //             fit: BoxFit.cover,
              //             colorFilter: ColorFilter.mode(Colors.black45, BlendMode.hue)
              //           ),
              //           boxShadow: <BoxShadow>[
              //             new BoxShadow(
              //               color: Colors.grey,
              //               offset: new Offset(0.0, 3.0),
              //               blurRadius: 5.0,
              //             )
              //           ]
              //         ),
              //       child: Padding(
              //         padding: EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 10.0),
              //         child: Text(
              //           "Yoga",
              //           style: Theme.of(context).textTheme.caption,
              //           textAlign: TextAlign.start,
              //         )),
              //     ),
              //   ),
              // ),
            
              // //Meditate
              // GestureDetector(
              //   onTap: (){
              //     print('Meditate');
              //   },
              //   child: Padding(
              //     padding: const EdgeInsets.only(bottom: 15.0),
              //     child: Container(
              //       height: 150,
              //       width: double.infinity,
              //       decoration: BoxDecoration(
              //           shape: BoxShape.rectangle,
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(8.0),
              //           image: DecorationImage(
              //             image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/ludus-health-coach.appspot.com/o/App%20Images%2FMeditate.jpg?alt=media&token=9597af4d-7a5f-45ee-be42-aba6c7bf99d4'),
              //             fit: BoxFit.cover,
              //             colorFilter: ColorFilter.mode(Colors.black45, BlendMode.hue)
              //           ),
              //           boxShadow: <BoxShadow>[
              //             new BoxShadow(
              //               color: Colors.grey,
              //               offset: new Offset(0.0, 3.0),
              //               blurRadius: 5.0,
              //             )
              //           ]
              //         ),
              //       child: Padding(
              //         padding: EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 10.0),
              //         child: Text(
              //           "Medita",
              //           style: Theme.of(context).textTheme.caption,
              //           textAlign: TextAlign.start,
              //         )),
              //     ),
              //   ),
              // ),
              
              //Nutrition
              // Expanded(
              //   child: GestureDetector(
              //     onTap: (){
              //       Navigator.push(context,
              //             MaterialPageRoute(builder: (context) => NutritionHome()));
              //     },
              //     child: Container(
              //       //height: MediaQuery.of(context).size.height*0.4,
              //       width: double.infinity,
              //       decoration: BoxDecoration(
              //           shape: BoxShape.rectangle,
              //           color: Colors.white,
              //           image: DecorationImage(
              //             image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/ludus-health-coach.appspot.com/o/App%20Images%2FNutrition.jpg?alt=media&token=667bda38-c114-4678-9e1b-ef2e79e68302'),
              //             fit: BoxFit.cover,
              //             colorFilter: ColorFilter.mode(Colors.black45, BlendMode.hue)
              //           ),
              //         ),
              //       child: Padding(
              //         padding: EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 10.0),
              //         child: Text(
              //           "Nutrición",
              //           style:Theme.of(context).textTheme.caption,
              //           textAlign: TextAlign.start,
              //         )),
              //     ),
              //   ),
              // ),

            // ],
          // )
      //   ),
      ),
    );
  }
}
