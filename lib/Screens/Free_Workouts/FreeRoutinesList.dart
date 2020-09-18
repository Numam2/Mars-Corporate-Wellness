import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Models/explore.dart';
import 'package:personal_trainer/Screens/Free_Workouts/RoutineIntro.dart';
import 'package:provider/provider.dart';

class FreeRoutinesList extends StatelessWidget {
  navigatetoDetail(
      context,
      String freeRoutine,
      String routineImage,
      String author,
      String routineTime,
      String description,
      List objectives,
      List equipment,
      String firstWeek,
      String firstDay) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RoutineIntro(
                freeRoutine: freeRoutine,
                routineImage: routineImage,
                author: author,
                routineTime: routineTime,
                description: description,
                objective: objectives,
                equipment: equipment,
                firstWeek: firstWeek,
                firstDay: firstDay)));
  }

  @override
  Widget build(BuildContext context) {
    
    final _routine = Provider.of<List<ExploreRoutines>>(context);

    if (_routine == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Container(
          height: 400,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
        ),
      );
    }

    final List<Widget> imageSliders = _routine
        .map((item) => InkWell(
          onTap: () => navigatetoDetail(context,
            item.name,
            item.image,
            item.author,
            item.duration,
            item.description,
            item.objectives,
            item.equipment,
            item.firstWeek,
            item.firstDay
          ),
          child: Container(
                child: Container(
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      child: Stack(
                        children: <Widget>[
                          Image.network(item.image,
                              fit: BoxFit.cover, width: 1000.0),
                          Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(200, 0, 0, 0),
                                    Color.fromARGB(0, 0, 0, 0)
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              padding: EdgeInsets.all(20.0),
                              child: Container(
                                width: double.infinity,
                                child: Row(children: <Widget>[
                                  Container(
                                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.5),
                                    child: Text(
                                      item.name,
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    item.duration,
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
        ))
        .toList();

    return CarouselSlider(
        options: CarouselOptions(
          autoPlay: false,
          aspectRatio: 2.0,
          enlargeCenterPage: true,
        ),
        items: imageSliders);

    // return ListView.builder(
    //     itemCount: _routine.length,
    //     scrollDirection: Axis.horizontal,
    //     shrinkWrap: true,
    //     physics: BouncingScrollPhysics(),
    //     itemBuilder: (_, index) {
    //       return FittedBox(
    //         child: Container(
    //           width: MediaQuery.of(context).size.width,
    //           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    //           child: InkWell(
    //             onTap: () => navigatetoDetail(context,
    //               _routine[index].name,
    //               _routine[index].image,
    //               _routine[index].author,
    //               _routine[index].duration,
    //               _routine[index].description,
    //               _routine[index].objectives,
    //               _routine[index].equipment
    //             ),
    //             child: Container(
    //               width: MediaQuery.of(context).size.width,
    //               margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
    //               child: Column(
    //                 children: <Widget>[
    //                   ///Image
    //                   Container(
    //                     height: 300,
    //                     width: double.infinity,
    //                     decoration: BoxDecoration(
    //                       color: Colors.grey[100],
    //                       borderRadius: BorderRadius.circular(8.0),
    //                       image: DecorationImage(
    //                         image: NetworkImage(_routine[index].image),
    //                         fit: BoxFit.cover,
    //                       ),
    //                     ),
    //                   ),

    //                   ///Text
    //                   Container(
    //                     width: double.infinity,
    //                     child: Row(children: <Widget>[
    //                       Padding(
    //                         padding:
    //                             const EdgeInsets.only(top: 12.0),
    //                         child: Container(
    //                           constraints: BoxConstraints(maxWidth: 105),
    //                           child: Text(
    //                             _routine[index].name,
    //                             textAlign: TextAlign.start,
    //                             style: GoogleFonts.montserrat(
    //                                 color: Colors.black,
    //                                 fontSize: 12,
    //                                 fontWeight: FontWeight.w500),
    //                           ),
    //                         ),
    //                       ),
    //                       Spacer(),
    //                       Padding(
    //                         padding:
    //                             const EdgeInsets.only(top: 12.0),
    //                         child: Text(
    //                           _routine[index].duration,
    //                           textAlign: TextAlign.start,
    //                           style: GoogleFonts.montserrat(
    //                             color: Colors.black45,
    //                             fontWeight: FontWeight.w400,
    //                             fontSize: 10,
    //                           ),
    //                         ),
    //                       ),
    //                     ]),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       );
    //     });
  }
}
