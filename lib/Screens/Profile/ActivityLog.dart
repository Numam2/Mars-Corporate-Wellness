import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_trainer/Models/userProfile.dart';

class ActivityLog extends StatelessWidget {

  final UserActivityList activities;
  ActivityLog({this.activities});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions:<Widget>[
          Container(
            width: 50,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close,
                color: Colors.black,
              ),
            ),
          ),
        ],
        title: Text(
          "Mi Actividad",
            style: Theme.of(context).textTheme.headline,
          ),
        centerTitle: true,
      ),

      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        color: Colors.white,
        height: double.infinity,
        width: double.infinity,
        child: ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: activities.userActivityList.length,
          itemBuilder: (context, index){

            List<UserActivity> activityList = activities.userActivityList.reversed.toList();

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children:<Widget>[

                  //Icon for activity
                  Icon(
                      Icons.fitness_center,
                      size: 20,
                      color: Colors.black,
                  ),
                  SizedBox(width: 15),

                  Text(
                    DateFormat.Md().format(activityList[index].date).toString(),
                    style: Theme.of(context).textTheme.display2,
                  ),
                  SizedBox(width: 15),

                  //Card with data
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        constraints: BoxConstraints(minHeight: 120),
                        width: double.infinity,
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: <BoxShadow>[
                            new BoxShadow(
                              color: Colors.grey[350],
                              offset: new Offset(0.0, 3.0),
                              blurRadius: 5.0,
                            )
                          ]),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:<Widget>[
                                                            
                              //Activity
                              Text(
                                activityList[index].trainingType,
                                style: Theme.of(context).textTheme.title,
                              ),
                              SizedBox(height: activityList[index].trainingSession == '' ? 0 : 5),
                              //Session
                              activityList[index].trainingSession == '' 
                                ? SizedBox()
                                : Text(
                                  activityList[index].trainingSession,
                                  style: Theme.of(context).textTheme.body1,
                                ),
                              SizedBox(height: 10),
                              //Duration
                              Text(
                                'Duración: ' + activityList[index].duration,
                                style: Theme.of(context).textTheme.body1,
                              ),
                              
                            ]
                          ),
                          
                      ),
                    ),
                  ),

                ] 
              ),
            );
          }
        )
        
        
      ),
    );
  }
}