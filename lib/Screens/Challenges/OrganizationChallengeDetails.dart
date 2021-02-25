import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/dates.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Challenges/OrgChalllengeAccepted.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class OrganizationChallengeDetails extends StatefulWidget {

  final String challengeID;
  final String title;
  final String description;
  final String image;
  final DateTime dateStart;
  final DateTime dateFinish;
  final String type;
  final int target;
  final List activeUsers;
  final String targetDescription;
  final String reward;
  final String organization;

  OrganizationChallengeDetails({this.challengeID, this.title, this.description, this.image, this.dateStart, this.dateFinish, this.type, this.target, this.activeUsers, this.targetDescription, this.reward, this.organization});

  @override
  _OrganizationChallengeDetailsState createState() => _OrganizationChallengeDetailsState();
}

class _OrganizationChallengeDetailsState extends State<OrganizationChallengeDetails> {

  @override
  Widget build(BuildContext context) {

    final userProfile = Provider.of<UserProfile>(context);

    //If challenge is completed
    if(userProfile.activeOrganizationChallenges['Challenge ID'] == 'Completo' || (userProfile.activeOrganizationChallenges['Completed Steps'] != null && userProfile.activeOrganizationChallenges['Target Steps'] == userProfile.activeOrganizationChallenges['Completed Steps'])){
      return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(bottom:20.0),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ///Image
                    Container(
                      height: MediaQuery.of(context).size.height*0.4,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(widget.image),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.grey[800], BlendMode.hardLight)),
                      ),
                      child: Stack(
                        children: <Widget>[
                          ///Back Button
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0, left: 20),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white38,
                                  ),
                                  child: Icon(Icons.keyboard_arrow_left, color: Colors.white)), 
                              ),
                            ),
                          ),
                          ///Title
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:<Widget>[
                                  Text(widget.title, style: Theme.of(context).textTheme.caption),
                                ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    ///Time and category                          
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:20.0, vertical:20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          ///Time
                          Icon(Icons.check, size: 15, color: Theme.of(context).accentColor),
                          SizedBox(width:5),
                          Text(
                            'Reto completo!',
                            style: Theme.of(context).textTheme.bodyText2
                          ),
                        ],
                      ),
                    ),

                    //StepCounter
                    (userProfile.activeOrganizationChallenges['Challenge ID'] == widget.challengeID)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          //Text
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              '${userProfile.activeOrganizationChallenges['Completed Steps']}/${widget.target} completos',
                              style: Theme.of(context).textTheme.headline6
                            ),
                          ),   
                          SizedBox(height: 10),
                          //Steps
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal:20.0),
                            child: StepProgressIndicator(
                              totalSteps: userProfile.activeOrganizationChallenges['Target Steps'],
                              currentStep: userProfile.activeOrganizationChallenges['Completed Steps'],
                              selectedColor: Theme.of(context).accentColor,
                              selectedSize: 4,
                              unselectedSize: 4,
                              unselectedColor: Theme.of(context).disabledColor.withOpacity(0.2),
                              padding: 0,
                            ),
                          ),
                          SizedBox(height: 30)
                        ]
                    )
                    : SizedBox(),
                    //Intro
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(widget.description,
                            style: Theme.of(context).textTheme.bodyText2)),
                    SizedBox(height: 20),                          

                    ///Details
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Detalles',
                        style: Theme.of(context).textTheme.headline6
                      ),
                    ),                    
                    SizedBox(height:20),
                    //Target
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.scope, size: 15, color: Colors.grey[800]),
                          SizedBox(width:10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'El reto',
                                style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                              ),
                              SizedBox(height: 5),
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width *0.8
                                ),
                                child: Text(
                                  '${widget.targetDescription}',
                                  style: Theme.of(context).textTheme.bodyText2
                                ),
                              ),
                            ]
                          ),
                        ]
                      )
                    ),
                    SizedBox(height: 20),
                    //Tiempo
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.calendar, size: 15, color: Colors.grey[800]),
                          SizedBox(width:10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.dateStart.day} de ${DatesDictionary().monthDictionary[widget.dateStart.month - 1]} - ${widget.dateFinish.day} de ${DatesDictionary().monthDictionary[widget.dateFinish.month - 1]} ${widget.dateFinish.year}',
                                style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Completaste el reto',
                                style: Theme.of(context).textTheme.bodyText2
                              ),
                            ]
                          ),
                        ]
                      )
                    ),
                    SizedBox(height: 20),
                    //Premios
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.gift, size: 15, color: Colors.grey[800]),
                          SizedBox(width:10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Premios',
                                style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                              ),
                              SizedBox(height: 5),
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width *0.8
                                ),
                                child: Text(
                                  '${widget.reward}',
                                  style: Theme.of(context).textTheme.bodyText2
                                ),
                              ),
                            ]
                          ),
                        ]
                      )
                    ),
                    SizedBox(height: 40),                          
                  ]),
            ),
          ),
        ),
      ),
    );
    }
    //If challenge is either in progress or out of date  
    else {
      return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            //Body
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom:20.0),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          ///Image
                          Container(
                            height: MediaQuery.of(context).size.height*0.4,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(widget.image),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                      Colors.grey[800], BlendMode.hardLight)),
                            ),
                            child: Stack(
                              children: <Widget>[
                                ///Back Button
                                Padding(
                                  padding: const EdgeInsets.only(top: 30.0, left: 20),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white38,
                                        ),
                                        child: Icon(Icons.keyboard_arrow_left, color: Colors.white)), 
                                    ),
                                  ),
                                ),
                                //Leave
                                (userProfile.activeOrganizationChallenges['Challenge ID'] == widget.challengeID)
                                ? Padding(
                                  padding: const EdgeInsets.only(top: 20.0, right: 20),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      icon: Icon(Icons.exit_to_app),
                                      iconSize: 24,
                                      color: Colors.white,
                                      onPressed: (){
                                        DatabaseService().deleteOrgChallenge();
                                      },                                      
                                    )
                                  ),
                                )
                                : SizedBox(),
                                ///Title
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:<Widget>[
                                        Text(widget.title, style: Theme.of(context).textTheme.caption),
                                      ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          ///Time and category                          
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal:20.0, vertical:20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                ///Time
                                Icon(Icons.watch_later, size: 15, color: Colors.grey[800]),
                                SizedBox(width:5),
                                (DateTime.now().difference(widget.dateFinish).inDays > 0)
                                ? Text(
                                  'Reto finalizado',
                                  style: Theme.of(context).textTheme.bodyText2
                                )
                                : Text(
                                  '${widget.dateFinish.difference(DateTime.now()).inDays} días restantes',
                                  style: Theme.of(context).textTheme.bodyText2
                                ),
                              ],
                            ),
                          ),

                          //StepCounter
                          (userProfile.activeOrganizationChallenges['Challenge ID'] == widget.challengeID)
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                //Text
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Text(
                                    '${userProfile.activeOrganizationChallenges['Completed Steps']}/${widget.target} completos',
                                    style: Theme.of(context).textTheme.headline6
                                  ),
                                ),   
                                SizedBox(height: 10),
                                //Steps
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal:20.0),
                                  child: StepProgressIndicator(
                                    totalSteps: userProfile.activeOrganizationChallenges['Target Steps'],
                                    currentStep: userProfile.activeOrganizationChallenges['Completed Steps'],
                                    selectedColor: Theme.of(context).accentColor,
                                    selectedSize: 4,
                                    unselectedSize: 4,
                                    unselectedColor: Theme.of(context).disabledColor.withOpacity(0.2),
                                    padding: 0,
                                  ),
                                ),
                                SizedBox(height: 30)
                              ]
                          )
                          : SizedBox(),
                          //Intro
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(widget.description,
                                  style: Theme.of(context).textTheme.bodyText2)),
                          SizedBox(height: 20),                          

                          ///Details
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              'Detalles',
                              style: Theme.of(context).textTheme.headline6
                            ),
                          ),                    
                          SizedBox(height:20),
                          //Target
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.scope, size: 15, color: Colors.grey[800]),
                                SizedBox(width:10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'El reto',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: MediaQuery.of(context).size.width *0.8
                                      ),
                                      child: Text(
                                        '${widget.targetDescription}',
                                        style: Theme.of(context).textTheme.bodyText2
                                      ),
                                    ),
                                  ]
                                ),
                              ]
                            )
                          ),
                          SizedBox(height: 20),
                          //Tiempo
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.calendar, size: 15, color: Colors.grey[800]),
                                SizedBox(width:10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${widget.dateStart.day} de ${DatesDictionary().monthDictionary[widget.dateStart.month - 1]} - ${widget.dateFinish.day} de ${DatesDictionary().monthDictionary[widget.dateFinish.month - 1]} ${widget.dateFinish.year}',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                    ),
                                    SizedBox(height: 5),
                                    (DateTime.now().difference(widget.dateFinish).inDays > 0)
                                    ? Text(
                                      'Reto finalizado',
                                      style: Theme.of(context).textTheme.bodyText2)
                                    : Text(
                                      'Quedan ${widget.dateFinish.difference(DateTime.now()).inDays} días',
                                      style: Theme.of(context).textTheme.bodyText2
                                    ),
                                  ]
                                ),
                              ]
                            )
                          ),
                          SizedBox(height: 20),
                          //Premios
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.gift, size: 15, color: Colors.grey[800]),
                                SizedBox(width:10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Premios',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: MediaQuery.of(context).size.width *0.8
                                      ),
                                      child: Text(
                                        '${widget.reward}',
                                        style: Theme.of(context).textTheme.bodyText2
                                      ),
                                    ),
                                  ]
                                ),
                              ]
                            )
                          ),
                          SizedBox(height: 40),                          
                        ]),
                  ),
                ),
              ),
            ///Button
            (userProfile.activeOrganizationChallenges['Challenge ID'] == widget.challengeID || DateTime.now().difference(widget.dateFinish).inDays > 0)
            ? SizedBox()
            : Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  child: RaisedButton(
                      color: Theme.of(context).accentColor,
                      child: Text(
                        "UNIRME AL RETO",
                        style: GoogleFonts.montserrat(color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: () {
                        DatabaseService().joinOrgChallenge(
                          widget.organization,
                          widget.challengeID,
                          widget.title,
                          widget.type,
                          widget.target,
                          widget.dateFinish                          
                        );
                        DatabaseService().recordOrganizationStats(userProfile.organization, 'Challenges Accepted');
                        showDialog(
                          context: context,
                          builder: (context) {                            
                            return OrganizationChallengeAccepted();
                          });
                      }
                    ),
                ),
              ),
            ),
          ]),
      ),
    );
    }
  }
}
