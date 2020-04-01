import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';



class ExerciseDetail extends StatefulWidget {

  final String exercise;
  ExerciseDetail ({Key key, this.exercise}) : super(key:key);

  @override
  _ExerciseDetailState createState() => _ExerciseDetailState();
}

class _ExerciseDetailState extends State<ExerciseDetail> {

Future getExerciseDetail() async {
  var firestore = Firestore.instance;
  DocumentSnapshot docRef = await firestore.collection("Exercise List").document(widget.exercise).get();  
  return docRef.data;
  }  
  
YoutubePlayerController _controller;
List<dynamic> equipment = [];
//List<dynamic> equipment = ["Barbell", "Dumbbell", "Kettlebell"];

  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(                  
               
               ///////////////// App bar /////////////////
               appBar: AppBar(
                  backgroundColor: Colors.white,

                  // Icon Navigator from Pop window to Home
                  leading: InkWell(
                            onTap:() {Navigator.pop(context);},
                            child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,),
                          ),                  
                  ),
  
                ///////////////// Body /////////////////
                body: 
                
                SingleChildScrollView(
                  child: FutureBuilder(
                    future: getExerciseDetail(),
                    builder: (context,snapshot){

                    ////handle wait time for the Future with connection state
                    if (snapshot.connectionState == ConnectionState.waiting){
                      return Center(
                      child: Loading()
                    );

                    ///Perform if there is data to show
                    } else {

                    List<dynamic> tags = snapshot.data["Tags"] as List;
                    List<dynamic> equipment = snapshot.data["Equipment"] as List;
                    String video = snapshot.data["Video"];
                    String videoId;
                    videoId = YoutubePlayer.convertUrlToId(video);


                        _controller = YoutubePlayerController(
                        initialVideoId: videoId,
                        flags: YoutubePlayerFlags(
                            mute: false,
                            autoPlay: false,
                            forceHideAnnotation: true,
                          ),
                        );

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[

                        ///Video Section
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            padding: EdgeInsets.all(0),
                            alignment: Alignment(0,0),
                            width: double.infinity,
                            height: 225,                        
                            //color: Colors.grey,
                            child: YoutubePlayer(
                              controller: _controller,
                              showVideoProgressIndicator: true,
                              onReady: () {
                                  print('Player is ready.');
                              },
                            ),
                          ),
                        ),

                        ///Text with exercise name
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20,15,20,15),
                          child: Container(
                            width: double.infinity,                       
                              child: Text(
                                widget.exercise, 
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 30.0, fontFamily: "Roboto", fontWeight: FontWeight.bold, color: Colors.black
                                  ),
                                ),
                            ),
                          ),

                        ///Tags list horizontally
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Container(
                            height: 40,
                            width: double.infinity,                       
                            //color: Colors.grey,
                            alignment: Alignment(0,0),
                              ///List of tags
                              child: 
                              ListView.builder(
                                itemCount: tags.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,                          
                                itemBuilder: (_, index){
                                  return  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 100,
                                      decoration: BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(25.0)),
                                      child: Center(
                                        child: Text(
                                          tags[index],
                                          style: TextStyle(
                                            color:Colors.white,
                                            fontSize: 12,
                                          )
                                          ),
                                      ),
                                    ),
                                      );
                                    }
                                  ),
                                ),
                              ),
                            
                        ///Text for Tips
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20,15,20,10),
                          child: Container(
                            width: double.infinity,                       
                              ///Text
                              child: Text(
                                "Tips", 
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20.0, fontFamily: "Roboto", fontWeight: FontWeight.bold, color: Colors.black
                                  ),
                                ),
                            ),
                          ),
                        
                        ///Tips section
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20,15,20,0),
                          child: Container(
                            width: double.infinity,
                            height: 50,                        
                            //color: Colors.grey,
                            child: Text(snapshot.data["Tips"].toString())
                          ),
                        ),
                       
                        ///Text for Equipment
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20,10,20,10),
                          child: Container(
                            width: double.infinity,                       
                              ///Text
                              child: Text(
                                "Equipment Options", 
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20.0, fontFamily: "Roboto", fontWeight: FontWeight.bold, color: Colors.black
                                  ),
                                ),
                            ),
                          ),

                        
                        ///List of Equipment Options
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Container(
                            height: 100,
                            width: double.infinity,                       
                            //color: Colors.grey,
                            alignment: Alignment(0,0),
                              ///List of tags
                              child: 
                              ListView.builder(
                                itemCount: equipment.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,                          
                                itemBuilder: (_, index){

                                  return  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 100,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: <BoxShadow>[
                                          new BoxShadow(
                                            color: Colors.black12,
                                            offset: new Offset(0.0, 10.0),
                                            blurRadius: 10.0,
                                          ),
                                        ]
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          //Equipment image
                                            Container(
                                              height: 50,
                                              width: 70,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                image: DecorationImage(
                                                  image: AssetImage('Images/Equipment/' + equipment[index] + '.jpg'),
                                                  fit: BoxFit.scaleDown,
                                                )
                                              ),
                                            ),
                                          //Exercise name
                                          Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Container(
                                              //color: Colors.blue,
                                              child: Text(
                                                equipment[index],
                                              ),
                                            )
                                          ),
                                        ],
                                      ),
                                      

                                    ),
                                      );
                                    }
                                  ),
                                ),
                              ),


                      ],
                    );
                  }
                  }
              ),
                )

          );       
        
  }
}