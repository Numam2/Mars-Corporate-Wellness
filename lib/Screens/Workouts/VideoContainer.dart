import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:video_player/video_player.dart';

class VideoContainer extends StatefulWidget {
  final String exerciseVideoURL;
  final String exerciseImage;
  final PageController pageController;
  final bool hasPageController;

  VideoContainer({this.exerciseVideoURL, this.exerciseImage, this.pageController, this.hasPageController});

  @override
  _VideoContainerState createState() => _VideoContainerState();
}

class _VideoContainerState extends State<VideoContainer>
    with SingleTickerProviderStateMixin {

  

  ///Video Controller
  VideoPlayerController _controller;
  Future<void> initializeVideo;
  String currentExerciseVideo = '';

  ///Retrieve video from Cache
  File fetchedFile;
  File videoFile;
  
  downloadMedia () async {
    fetchedFile = await DefaultCacheManager().getSingleFile(widget.exerciseVideoURL);
    setState((){
      videoFile = fetchedFile;
      print ('File fetched: ${fetchedFile.path}');
    });
    print(videoFile.path);
  }

  @override
  void initState() {

    try {

      downloadMedia().whenComplete(() {
        setState(() {});
        print("success");

        _controller = VideoPlayerController.file(videoFile);
        initializeVideo = _controller.initialize();
        _controller.play();
        _controller.setLooping(true);
        _controller.setVolume(0);      
      
      }).catchError((error, stackTrace) {
        print("outer: $error");
      });
          
    } catch (e) {
      print(e);
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (widget.exerciseVideoURL == null || widget.exerciseVideoURL == '' || videoFile == null) {
      return Container(
        height: 200,
      );
      // Container(
      //   height: 300,
      //   width: double.infinity,
      //   decoration: BoxDecoration(
      //     image: DecorationImage(
      //       image: NetworkImage(widget.exerciseImage),
      //       fit: BoxFit.cover,
      //     ),
      //   ),
      // );
    }
    return
      ///Video
      Container(
        height: 200,
        width: double.infinity,
        child: Stack(children: <Widget>[
          ///Video
          Container(
            height: double.infinity,
            width: double.infinity,
            child: FutureBuilder(
                  future: initializeVideo,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller));
                    } else {
                      return Center(
                        child: SizedBox(),
                      );
                    }
              })
          ),

          ///Go to List View
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: widget.hasPageController
              ? InkWell(
                  onTap: () {    
                    widget.pageController.animateToPage(0, duration: Duration(milliseconds: 100), curve: Curves.ease);         
                  },
                  child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.black38),
                      child: Icon(Icons.format_list_bulleted,
                              color: Colors.white, size: 20)),
                )
              : InkWell(
                  onTap: () {    
                    Navigator.of(context).pop();         
                  },
                  child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.black38),
                      child: Icon(Icons.keyboard_arrow_left,
                              color: Colors.white, size: 20)),
                ),
            ),
          ),

          ///Play/Pause
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: () {
                  if (_controller.value.isPlaying) {
                    setState(() {
                      _controller.pause();
                    });
                  } else {
                    setState(() {
                      _controller.play();
                    });
                  }
                },
                child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.black38),
                    child: _controller.value.isPlaying
                        ? Icon(Icons.pause, color: Colors.white, size: 20)
                        : Icon(Icons.play_arrow,
                            color: Colors.white, size: 20)),
              ),
            ),
          )
        ]),
      );
  }

  
}
