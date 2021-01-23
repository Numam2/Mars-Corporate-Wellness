import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/weeks.dart';
import 'package:personal_trainer/Screens/Workouts/DailyWorkout.dart';
import 'package:personal_trainer/Screens/Workouts/DownloadWorkout.dart';
import 'package:provider/provider.dart';

class IndividualWorkoutIntro extends StatelessWidget {
  final String freeRoutine;
  final String routineImage;
  final String author;
  final String routineTime;
  final String description;
  final List objective;
  final List equipment;
  IndividualWorkoutIntro(
      {Key key,
      this.freeRoutine,
      this.routineImage,
      this.author,
      this.routineTime,
      this.description,
      this.objective,
      this.equipment})
      : super(key: key);

  final String collection = 'Free Routines';

  @override
  Widget build(BuildContext context) {

    return StreamProvider<List<WeekDays>>.value(
      value: DatabaseService().weekDays(collection, freeRoutine, 'Week 1'),
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          body: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ///Image
                        Container(
                          height: MediaQuery.of(context).size.height*0.4,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(routineImage),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.grey[800], BlendMode.hardLight)),
                          ),
                          child: Stack(
                            children: <Widget>[
                              ///Back Button
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0, left: 20),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white38,
                                      ),
                                      child: Icon(Icons.keyboard_arrow_left, color: Colors.white)),
                                  ),
                                ),
                              ),
                              ///Title
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:<Widget>[
                                      Text(freeRoutine, style: Theme.of(context).textTheme.caption),
                                      SizedBox(height:5),
                                      Text('Por: $author' ,
                                        style: GoogleFonts.montserrat(fontWeight: FontWeight.w300, color: Colors.white, fontSize: 12),
                                      )
                                    ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),

                        ///Duration Text
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          width: double.infinity,
                          child: Text(routineTime.toUpperCase(),
                              style: GoogleFonts.montserrat(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black45)),
                        ),
                        SizedBox(height: 20),

                        ///Description Text
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          width: double.infinity,
                          child: Text(description,
                              style: GoogleFonts.montserrat(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black)),
                        ),
                        SizedBox(height: 30),

                        ///Title for Objectives
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          width: double.infinity,
                          child: Text('Lo que obtendrás',
                              style: Theme.of(context).textTheme.title),
                        ),

                        ///List of Objectives
                        Container(
                          width: double.infinity,
                          child: ListView.builder(
                              itemCount: objective.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 8),
                                  child: Container(
                                    width: double.infinity,
                                    height: 30,
                                    child: Row(children: <Widget>[
                                      //Icon
                                      Container(
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: <BoxShadow>[
                                              new BoxShadow(
                                                color: Colors.grey[350],
                                                offset: new Offset(0.0, 3.0),
                                                blurRadius: 5.0,
                                              )
                                            ]),
                                        child: Icon(Icons.check,
                                            color: Theme.of(context).accentColor,
                                            size: 15),
                                      ),
                                      SizedBox(width: 15.0),

                                      ///Objetivo
                                      Text(objective[index],
                                          style: GoogleFonts.montserrat(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black)),
                                    ]),
                                  ),
                                );
                              }),
                        ),
                        SizedBox(height: 20),

                        ///Title for Equipment                        
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          width: double.infinity,
                          child: Text('Materiales',
                              style: Theme.of(context).textTheme.title),
                        ),
                        SizedBox(height: 15),

                        ///List of Equipment Options
                        (equipment == null || equipment.length < 1)
                        ? Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9),
                          child: Text(
                            "Puedes completar este entrenamiento sin ningún tipo de material",
                            style: GoogleFonts.montserrat(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black)
                          )
                        )
                        : Container(
                          height: 110,
                          width: double.infinity,
                          margin: EdgeInsets.only(left: 15.0),

                          ///List of equipment
                          child: ListView.builder(
                              itemCount: equipment.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (_, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 100,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: <BoxShadow>[
                                          new BoxShadow(
                                            color: Colors.grey[350],
                                            offset: new Offset(0.0, 3.0),
                                            blurRadius: 5.0,
                                          )
                                        ]),
                                    child: Column(
                                      children: <Widget>[
                                        //Equipment image
                                        Container(
                                          height: 50,
                                          width: 70,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    'Images/Equipment/' +
                                                        equipment[index] +
                                                        '.jpg'),
                                                fit: BoxFit.scaleDown,
                                              )),
                                        ),
                                        SizedBox(height: 5),
                                        //Equipment name
                                        Text(
                                          equipment[index],
                                          style: GoogleFonts.montserrat(
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                        SizedBox(height: 60),
                      ]),
                ),
              ),

              ///Button
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        child: Text(
                          "EMPEZAR",
                          style: GoogleFonts.montserrat(color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: ()   {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  DownloadWorkout(
                                        collection: collection,
                                        id: 'Individual Workouts',
                                        weekNo: 'Workout List',
                                        day: freeRoutine,
                                      )));
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
