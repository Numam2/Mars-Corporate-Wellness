import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Models/explore.dart';
import 'package:personal_trainer/Screens/Free_Workouts/Free_Routines.dart';
import 'package:provider/provider.dart';

class FreeRoutinesList extends StatelessWidget {
  navigatetoDetail(context, String freeRoutine) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FreeRoutineView(freeRoutine: freeRoutine)));
  }

  @override
  Widget build(BuildContext context) {

    final _routine = Provider.of<List<ExploreRoutines>>(context);

      return ListView.builder(
        itemCount: _routine.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, index) {
          return Padding(
              padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: InkWell(
                onTap: () => navigatetoDetail(context, _routine[index].name),
                child: Container(
                  height: 150,
                  width: 190,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: <BoxShadow>[
                        new BoxShadow(
                            color: Colors.black12,
                            offset: new Offset(5.0, 5.0),
                            blurRadius: 5.0,
                            spreadRadius: 0)
                      ]),
                  margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
                  child: Column(
                    children: <Widget>[
                      ///Image
                      Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(_routine[index].image),
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
                                const EdgeInsets.only(top: 12.0, left: 8.0),
                            child: Text(
                              _routine[index].name,
                              textAlign: TextAlign.start,
                              style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 12.0, right: 8.0),
                            child: Text(
                              _routine[index].duration,
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
