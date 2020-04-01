import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:personal_trainer/Firebase_Services/auth.dart';
import 'package:personal_trainer/Screens/Challenges/MyChallenges.dart';
import 'package:personal_trainer/Screens/Home/Workout_Home.dart';
import 'package:personal_trainer/Screens/Profile/Profile.dart';
import 'package:personal_trainer/Screens/wrapper.dart';

class InicioNew extends StatefulWidget {

  @override
  _InicioNewState createState() => _InicioNewState();
}

class _InicioNewState extends State<InicioNew> {
  final AuthService _auth = AuthService();

  int pageIndex = 1;

  //// Create all pages for Bottom bar Navigation
  final WorkoutsHome _workoutView = WorkoutsHome();
  final MyChallenges _myChallenges = MyChallenges();
  final ProfilePage _profilePage = ProfilePage();

  Widget _showPage = new WorkoutsHome();

  Widget _pageChooser(int page){
    switch(page){

      case 0:
      return _workoutView;
      break; 

      case 1:
      return _myChallenges;
      break; 

      case 2:
      return _profilePage;
      break;

      default:
      return new Container(
        child: Center(
          child: Text(
            "Oops.. Seems like you have not selected any page"
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      //Page color
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,

        //App Bar design
        appBar: AppBar(
          backgroundColor: Colors.black,//Colors.blueGrey.shade900,
          elevation: 0.0,
          title: Text("",textAlign: TextAlign.center
            ),
          actions: <Widget>[
              FlatButton.icon(
                icon: Icon(
                  Icons.exit_to_app,
                   color: Colors.white,),
                label: Text(
                  "log out",
                   style: TextStyle(color: Colors.white, fontSize: 10)),
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Wrapper()));
                },
              )
            ],
          ),


        body: Container(
          child: _showPage,
        ),

        bottomNavigationBar: CurvedNavigationBar(
          color: Colors.black,//.blueGrey.shade900,
          backgroundColor: Colors.transparent,
          //buttonBackgroundColor: Colors.white,
          height: 60.0,
          items: <Widget>[            
            Icon(Icons.fitness_center, size: 20, color: Colors.white),   
            Icon(Icons.event_available, size: 20, color: Colors.white),         
            Icon(Icons.person, size: 20, color: Colors.white),            
            // Icon(Icons.show_chart, size: 25, color: Colors.white),
          ],
          animationDuration: Duration(milliseconds: 250),
          onTap: (int tappedIndex){
            setState((){
              _showPage = _pageChooser(tappedIndex);
            });
          }
        ),

    );
  }
}
                
                
                
                       
                         