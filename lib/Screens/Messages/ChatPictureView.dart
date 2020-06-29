import 'package:flutter/material.dart';

class ChatPictureView extends StatelessWidget {

  final String image;
  ChatPictureView({this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() => Navigator.of(context).pop(),
      child: Container(
        color: Colors.black,
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Image.network(image, fit: BoxFit.fitWidth)),
      ),
    );
  }
}