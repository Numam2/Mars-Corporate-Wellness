import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Profile/ActivityLog.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityLogBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _activities = Provider.of<UserActivityList>(context);

    if (_activities == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: <BoxShadow>[
                  new BoxShadow(
                    color: Colors.grey[350],
                    offset: new Offset(0.0, 3.0),
                    blurRadius: 5.0,
                  )
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20.0),
                  child: Container(
                    width: 200,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 15.0),
                  child: Container(
                    width: 75,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10.0),
                  child: Container(
                    width: 150,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
              ],
            )),
      );
    } else if (_activities.userActivityList.length == 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(          
          children:<Widget>[ 
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              //Titulo
              Text('Mi Actividad', style: Theme.of(context).textTheme.title),              
            ]),
            SizedBox(height:15),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: <BoxShadow>[
                    new BoxShadow(
                      color: Colors.grey[350],
                      offset: new Offset(0.0, 3.0),
                      blurRadius: 5.0,
                    )
                  ]),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    //Check
                    Icon(CupertinoIcons.check_mark_circled,
                        color: Theme.of(context).accentColor, size: 25),
                    SizedBox(width: 10),

                    //Title and History Column
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[                          
                          //Activity
                          Container(
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.3),
                            child: Text(
                              'Acá podrás ver lo que has hecho',
                              style: Theme.of(context).textTheme.body1,
                            ),
                          ),
                        ]),
                    Spacer(),

                    //See more Button
                    Container(
                        height: 80,
                        child: Image(
                            image: AssetImage(
                                'Images/Illustration Woman Exercising.jpg'),
                            fit: BoxFit.fitHeight)),
                  ])),
          ]),
      );
    } else {
      final lastActvityType = _activities.userActivityList.last.trainingType;
      final lastActvityDuration = _activities.userActivityList.last.duration;
      final lastActvityDate = _activities.userActivityList.last.date;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            //Titulo
            Text('Mi Actividad', style: Theme.of(context).textTheme.title),
            Spacer(),
            //Ver mas
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ActivityLog(activities: _activities)));
              },
              child: Text(
                'Ver más',
                style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).primaryColor),
              ),
            ),
          ]),
          SizedBox(height:15),
          Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: <BoxShadow>[
                    new BoxShadow(
                      color: Colors.grey[350],
                      offset: new Offset(0.0, 3.0),
                      blurRadius: 5.0,
                    )
                  ]),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    //Check
                    Icon(CupertinoIcons.check_mark_circled,
                        color: Theme.of(context).accentColor, size: 20),
                    SizedBox(width: 10),

                    //Title and History Column
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[                          
                          //Date
                          Text(
                            timeago.format(lastActvityDate, locale: 'es'),
                            style: Theme.of(context).textTheme.body1,
                          ),
                          SizedBox(height: 10),
                          //Activity
                          Container(
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.42),
                            child: Text(lastActvityType,
                              style: GoogleFonts.montserrat(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(height: 5),
                          //Duration
                          Text(
                            'Duración: ' + lastActvityDuration,
                            style: Theme.of(context).textTheme.display2,
                          ),
                        ]),
                    Spacer(),

                    //See more Button
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[                          
                          //Ilustracion
                          Container(
                            width: MediaQuery.of(context).size.width *0.25,
                            child: Image(
                                  image: AssetImage(
                                      'Images/Illustration Woman Exercising.jpg'),
                                  fit: BoxFit.fitHeight))
                        ]),
                  ])),
        ]),
      );
    }
  }
}
