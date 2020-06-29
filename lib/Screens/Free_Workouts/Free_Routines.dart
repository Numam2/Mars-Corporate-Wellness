import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/weeks.dart';
import 'package:personal_trainer/Screens/Workouts/DailyWorkout.dart';
import 'package:provider/provider.dart';

class FreeRoutineView extends StatefulWidget {

  final String freeRoutine;
  final String routineImage;
  final String routineTime;
  final String description;
  final List objective;
  final List equipment;
  FreeRoutineView ({Key key, this.freeRoutine, this.routineImage, this.routineTime, this.description, this.objective, this.equipment}) : super(key:key);

  @override
  _FreeRoutineViewState createState() => _FreeRoutineViewState();
}

class _FreeRoutineViewState extends State<FreeRoutineView> with SingleTickerProviderStateMixin {

  String collection = 'Free Routines';

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<WeekDays>>.value(
      value: DatabaseService().weekDays(collection, widget.freeRoutine, 'Week 1'),
        child: Scaffold(

          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black,
              ),
            ),            
          ),

          body: Container(
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
                height: 250,
                width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.routineImage),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(Colors.grey[800], BlendMode.hardLight)
                      ),
                  ),
              ),
              SizedBox(height:20),

              //Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  widget.freeRoutine,
                  style: GoogleFonts.montserrat(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)
                ),
              ),
              SizedBox(height:10),
              
              ///Duration Text
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: double.infinity,
                child: Text(widget.routineTime.toUpperCase(),
                    style: GoogleFonts.montserrat(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black)),
              ),
              SizedBox(height:20),

              ///Description Text
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: double.infinity,
                child: Text(widget.description,
                  style: GoogleFonts.montserrat(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black
                  )
                ),
              ),
              SizedBox(height:30),

              ///Title for Objectives
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: double.infinity,
                child: Text('Lo que obtendrás',
                  style: Theme.of(context).textTheme.title
                ),
              ),
              SizedBox(height:20),

              ///List of Objectives
              Container(
                width: double.infinity,
                child: ListView.builder(
                  itemCount: widget.objective.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index){
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                      child: Container(
                        width: double.infinity,
                        height: 30,
                        child: Row(
                          children:<Widget> [
                            //Icon
                            Icon(
                              Icons.check_circle,
                              color: Theme.of(context).accentColor,
                              size: 25
                            ),
                            SizedBox(width: 15.0),
                            ///Objetivo
                            Text(widget.objective[index],
                              style: GoogleFonts.montserrat(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black)),
                          ]
                        ),
                      ),
                    );
                  }
                ),
              ),
              SizedBox(height:20),

              ///Title for Equipment
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: double.infinity,
                child: Text('Materiales',
                  style: Theme.of(context).textTheme.title
                ),
              ),
              SizedBox(height:15),

              ///List of Equipment Options
              Container(
                height: 110,
                width: double.infinity,
                margin: EdgeInsets.only(left: 15.0),

                ///List of equipment
                child: ListView.builder(
                    itemCount: widget.equipment.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 100,
                          //height: 350,
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
                                    image: AssetImage('Images/Equipment/' +
                                          widget.equipment[index] +
                                          '.jpg'),
                                      fit: BoxFit.scaleDown,
                                    )),
                              ),
                              SizedBox(height: 5),
                              //Equipment name
                              Text(
                                widget.equipment[index],
                                style: GoogleFonts.montserrat(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),

              /// Button
              Padding(
                padding: EdgeInsets.symmetric(vertical: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  ///Chat with Mars Coach
                  Container(
                    width: 150,
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        "Empezar",
                        style: GoogleFonts.montserrat(
                          color: Colors.white),
                        ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context) => DailyWorkout(
                          collection: 'Free Routines',
                          weekNo: 'Week 1',
                          day: 'Day 1',
                          id: widget.freeRoutine,
                          )));
                        }
                      ),
                    ),
                  ],
                )
              ),   
            
                
              ]),
            ),
          ),
      ),
    ); 
      
  }
}

