import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Models/exerciseDetail.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:provider/provider.dart';

class ExerciseDetailPage extends StatefulWidget {
  final String exerciseName;
  ExerciseDetailPage({Key key, this.exerciseName}) : super(key: key);

  @override
  _ExerciseDetailPageState createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  @override
  Widget build(BuildContext context) {
    final exercise = Provider.of<ExerciseDetail>(context);

    if (exercise == null) {
      return Center(
        child: Loading(),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ///Video Section
        // YoutubeVideoPlayer(videoURL: exercise.video),

        ///Text with exercise name
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
          child: Container(
            width: double.infinity,
            child: Text(
              widget.exerciseName,
              textAlign: TextAlign.start,
              style: GoogleFonts.montserrat(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
          ),
        ),

        ///Tags list horizontally
        // Container(
        //   height: 70,
        //   width: double.infinity,
        //   alignment: Alignment(0, 0),

          ///List of tags
        //   child: ListView.builder(
        //       itemCount: exercise.tags.length,
        //       scrollDirection: Axis.horizontal,
        //       shrinkWrap: true,
        //       physics: BouncingScrollPhysics(),
        //       itemBuilder: (_, index) {
        //         return Padding(
        //           padding: (index == exercise.equipment.length -1 ) ? EdgeInsets.symmetric(horizontal: 10.0, vertical: 20) : EdgeInsets.only(left: 10.0, bottom: 20, top: 20),
        //           child: Container(
        //             width: 100,
        //             decoration: BoxDecoration(
        //                 color: Theme.of(context).accentColor,
        //                 shape: BoxShape.rectangle,
        //                 borderRadius: BorderRadius.circular(25.0)),
        //             child: Center(
        //               child: Text(exercise.tags[index],
        //                   style: GoogleFonts.montserrat(
        //                     color: Colors.white,
        //                     fontSize: 11,
        //                   )),
        //             ),
        //           ),
        //         );
        //       }),
        // ),
        SizedBox(height: 15),

        ///Text for Tips
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            width: double.infinity,

            ///Text
            child: Text("Tips",
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.title),
          ),
        ),
        SizedBox(height: 20),

        ///Tips section
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
        //   child: Container(
        //       width: double.infinity,
        //       height: 50,
        //       child: Text(
        //         //exercise.tips,
        //         style: GoogleFonts.montserrat(fontSize: 12),
        //       )),
        // ),
        SizedBox(height: 20),

        ///Text for Equipment
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            width: double.infinity,

            ///Text
            child: Text("Equipment Options",
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.title),
          ),
        ),
        SizedBox(height: 15),

        ///List of Equipment Options
        // Container(
        //   height: 110,
        //   width: double.infinity,
        //   ///List of equipment
        //   child: ListView.builder(
        //       itemCount: exercise.equipment.length,
        //       scrollDirection: Axis.horizontal,
        //       shrinkWrap: true,
        //       physics: BouncingScrollPhysics(),
        //       itemBuilder: (_, index) {
        //         return Padding(
        //           padding: (index == exercise.equipment.length -1 ) ? EdgeInsets.symmetric(horizontal: 20.0, vertical: 10) : EdgeInsets.only(left: 20.0, bottom: 10, top: 10),
        //           child: Container(
        //             width: 100,
        //             //height: 350,
        //             padding: EdgeInsets.all(10),
        //             decoration: BoxDecoration(
        //                 color: Colors.white,
        //                 borderRadius: BorderRadius.circular(12),
        //                 boxShadow: <BoxShadow>[
        //                   new BoxShadow(
        //                     color: Colors.grey[350],
        //                     offset: new Offset(0.0, 3.0),
        //                     blurRadius: 5.0,
        //                   )
        //                 ]),
        //             child: Column(
        //               children: <Widget>[
        //                 //Equipment image
        //                 Container(
        //                   height: 50,
        //                   width: 70,
        //                   decoration: BoxDecoration(
        //                       shape: BoxShape.rectangle,
        //                       image: DecorationImage(
        //                         image: AssetImage('Images/Equipment/' +
        //                             exercise.equipment[index] +
        //                             '.jpg'),
        //                         fit: BoxFit.scaleDown,
        //                       )),
        //                 ),
        //                 SizedBox(height: 5),
        //                 //Equipment name
        //                 Text(
        //                   exercise.equipment[index],
        //                   style: GoogleFonts.montserrat(fontSize: 12),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         );
        //       }),
        // ),
        SizedBox(height: 30),
      ],
    );
  }
}
