import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Models/weeks.dart';
import 'package:personal_trainer/Screens/Workouts/DailyWorkout.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:provider/provider.dart';

class WeekDaysList extends StatelessWidget {

  final String collection;
  final String weekNo;
  final String id;
  WeekDaysList({this.weekNo, this.id, this.collection});

  @override
  Widget build(BuildContext context) {

    final days = Provider.of<List<WeekDays>>(context);

    if (days == null){
      return Center(
        child: Loading()
      );
    }    

    return Container(        
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        //shrinkWrap: true,
        itemCount: days.length,
        itemBuilder: (_, index) {
            return Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: <BoxShadow>[
                        new BoxShadow(
                          color: Colors.black12,
                          offset: new Offset(0.0, 10.0),
                          blurRadius: 10.0,
                        )
                      ]),
                  child: InkWell(
                    onTap: () {
                       Navigator.push(
                         context, MaterialPageRoute(builder: (context) => DailyWorkout(collection: collection, day: days[index].day, weekNo: weekNo, id: id)));
                        },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(25, 15, 40, 10),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ///Number of week
                                Container(
                                  child: Text(
                                      days[index].day,
                                      style: GoogleFonts.montserrat(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300)),
                                ),
                                SizedBox(height: 10),

                                ///Body Part
                                Row(children: <Widget>[
                                  Container(
                                    height: 30,
                                    child: Text(
                                      days[index].bodyPart,
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),

                                  ///Focus
                                  Container(
                                    height: 30,
                                    child: Text(
                                      days[index].focus,
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ]),
                              ],
                            ),

                            Spacer(),

                            ///Time

                            Text(
                              days[index].time,
                              style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontWeight: FontWeight.w200,
                                fontSize: 11,
                              ),
                            )
                          ]),
                    ),
                  ),
                ));
          }),
    );
  }
}
