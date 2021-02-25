import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Models/challenge.dart';
import 'package:personal_trainer/Models/dates.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Challenges/OrganizationChallengeDetails.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class OrganizationChallengeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final _user = Provider.of<UserProfile>(context);
    final _challenge = Provider.of<List<ChallengeContest>>(context);

    if (_challenge == null || _user == null){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Container(
          height: 200,
          width: MediaQuery.of(context).size.width * 0.75,
          color: Colors.grey[250],
        ),
      );
    }
    
    return Container(
          height: 200,        
          child: ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: _challenge.length,
              itemBuilder: (context, index) {
                return Padding(
                   padding: (index == _challenge.length - 1)
                        ? const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10)
                        : const EdgeInsets.only(
                            left: 20.0, top: 10, bottom: 10),
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrganizationChallengeDetails(
                                challengeID: _challenge[index].challengeID,
                                title: _challenge[index].title,
                                description: _challenge[index].description,
                                image: _challenge[index].image,
                                type: _challenge[index].activityType,
                                dateStart: _challenge[index].dateStart,
                                dateFinish: _challenge[index].dateFinish,
                                target: _challenge[index].target,
                                activeUsers: _challenge[index].activeUsers,
                                reward: _challenge[index].reward,
                                targetDescription: _challenge[index].targetDescription,
                                organization: _user.organization,
                              ))),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            child: Stack(
                              children: <Widget>[
                                Image.network(_challenge[index].image,
                                    fit: BoxFit.cover, width: 1000.0),
                                Positioned(
                                  bottom: 0.0,
                                  left: 0.0,
                                  right: 0.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color.fromARGB(200, 0, 0, 0),
                                          Color.fromARGB(0, 0, 0, 0)
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                    padding: EdgeInsets.all(20.0),
                                    child: Container(
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                        Container(
                                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.65),
                                          child: Text(
                                            _challenge[index].title,
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.montserrat(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        (_user.activeOrganizationChallenges['Challenge ID'] == _challenge[index].challengeID)
                                        ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            //Text
                                            Text(
                                              '${_user.activeOrganizationChallenges['Completed Steps']}/${_challenge[index].target}',
                                              style:GoogleFonts.montserrat(
                                                color: Colors.white70,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                              ),
                                            ),   
                                            SizedBox(height: 10),
                                            //Steps
                                            StepProgressIndicator(
                                              totalSteps: _user.activeOrganizationChallenges['Target Steps'],
                                              currentStep: _user.activeOrganizationChallenges['Completed Steps'],
                                              selectedColor: Theme.of(context).accentColor,
                                              selectedSize: 4,
                                              unselectedSize: 4,
                                              unselectedColor: Theme.of(context).disabledColor.withOpacity(0.2),
                                              padding: 0,
                                            ),
                                          ],
                                        )
                                        : Text(
                                          '${DatesDictionary().monthDictionary[_challenge[index].dateStart.month - 1]}',
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.montserrat(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        ),
                    ));                
              }),
        );
  }
}