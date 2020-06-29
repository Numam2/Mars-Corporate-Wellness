// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class YoutubeVideoPlayer extends StatefulWidget {
//   final String videoURL;
//   YoutubeVideoPlayer({this.videoURL});

//   @override
//   _YoutubeVideoPlayerState createState() => _YoutubeVideoPlayerState();
// }

// class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer> {

//   YoutubePlayerController _controller;
//   String videoId;

//   @override
//   void initState() {
//     videoId = YoutubePlayer.convertUrlToId(widget.videoURL);

//     _controller = YoutubePlayerController(
//       initialVideoId: videoId,
//       flags: YoutubePlayerFlags(
//         hideThumbnail: true,
//         mute: false,
//         autoPlay: true,
//         loop: false,
//         controlsVisibleAtStart: false,
//         enableCaption: false,
//       ),
//     );
//     super.initState();
//   }  

//   @override
//   Widget build(BuildContext context) {

//     if (widget.videoURL == '' || widget.videoURL == null){
//       return SizedBox();
//     }
//     return Padding(
//       padding: const EdgeInsets.all(0.0),
//       child: Container(
//         padding: EdgeInsets.all(0),
//         width: double.infinity,
//         height: double.infinity,
//         child: YoutubePlayer(
//           controller: _controller,
//           aspectRatio: 16/9,
//           controlsTimeOut: Duration(seconds: 3) ,
//           showVideoProgressIndicator: false,
//         ),

//       ),
//     );
//   }
// }
