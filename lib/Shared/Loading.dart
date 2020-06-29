import "package:flutter/material.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SpinKitRotatingCircle(
          color: Colors.blueGrey.shade900,
          size: 30.0,
        ),
      )
    );
  }
}

//// Message user loading
class MessagesLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: double.infinity,
        height: 80.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ///User picture
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[100],
                child: ClipOval(
                  child: Container(
                    height: 60,
                    width: 60,
                    color: Colors.grey[200],
                ),
              ),
            ),
            SizedBox(width: 15),

            Column( 
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ///User Name
                Container(
                  height: 14,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(Radius.circular(25))
                  ),
                ),
                SizedBox(height: 3),
                Container(
                  height: 14,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.all(Radius.circular(25))
                  ),
                ),
            ],)
            
            ///User Bio
          ],
        )
      ),
    );
  }
}

/// Group page loading
/// Normal page loading