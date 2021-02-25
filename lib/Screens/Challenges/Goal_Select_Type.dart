import 'package:flutter/material.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Challenges/GoalCreate.dart';

class GoalSelectType extends StatelessWidget {

  final UserProfile userProfile;
  GoalSelectType({this.userProfile});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(        
        backgroundColor: Colors.white,
        elevation: 0.0,     
        actions:<Widget>[
          IconButton(
            onPressed:()=> Navigator.of(context).pop(),
            icon: Icon(Icons.close, color: Colors.black, size:20),
            ),
          ],
        ),

        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:<Widget>[
              Text(
                "Tipo de meta",
                style: Theme.of(context).textTheme.title,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 50),
              Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:<Widget>[ 
                    //Peso
                    Column(
                      children:<Widget>[
                        InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => GoalCreate(
                                goalType: 'Weight',
                                userProfile: userProfile,
                              )));
                          },
                          child: Container(
                            height: 75,
                            width: 75,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.fromBorderSide(BorderSide(color:Colors.grey, width: 0.5)),                          
                            ),
                            child: Icon(
                              Icons.trending_up,
                              size: 40,
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Peso',
                          style: Theme.of(context).textTheme.body1,
                        )
                    ]),
                    Spacer(),
                    //Other
                    Column(
                      children:<Widget>[
                        InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => GoalCreate(
                                goalType: 'Other',
                                userProfile: userProfile,
                              )));
                          },
                          child: Container(
                            height: 75,
                            width: 75,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.fromBorderSide(BorderSide(color:Colors.grey, width: 0.5)),                          
                            ),
                            child: Icon(
                              Icons.today,
                              size: 40,
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Otro',
                          style: Theme.of(context).textTheme.body1,
                        )
                    ]),
                ]),
              ),
              SizedBox(height: 50),
            ] 
          ),
        ),
      ),
    );
  }
}