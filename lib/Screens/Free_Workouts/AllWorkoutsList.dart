import 'package:flutter/material.dart';
import 'package:personal_trainer/Models/explore.dart';
import 'package:personal_trainer/Screens/Free_Workouts/IndividualWorkoutIntro.dart';
import 'package:provider/provider.dart';

class AllWorkoutsList extends StatelessWidget {
  final List difficulty = ['Fácil', 'Intermedio', 'Avanzado', 'Difícil'];

  @override
  Widget build(BuildContext context) {
    final _routine = Provider.of<List<ExploreWorkouts>>(context);

    if (_routine == null) {
      return Flexible(
        fit: FlexFit.loose,
        child: ListView.builder(
            itemCount: 3,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: <Widget>[
                      ///Image
                      Container(
                        height: double.infinity,
                        width: MediaQuery.of(context).size.width * 0.35,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.grey[350],
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            boxShadow: <BoxShadow>[
                              new BoxShadow(
                                color: Colors.grey[350],
                                offset: new Offset(0.0, 3.0),
                                blurRadius: 5.0,
                              )
                            ]),
                      ),

                      ///Info
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ///Name
                            Container(
                              height: 20,
                              width: MediaQuery.of(context).size.width * 0.45,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.grey[350],
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                            SizedBox(height: 10),

                            ///Intro
                            Container(
                              height: 15,
                              width: MediaQuery.of(context).size.width * 0.35,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              height: 15,
                              width: MediaQuery.of(context).size.width * 0.40,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                            Spacer(),

                            ///Time and Category
                            Container(
                              height: 15,
                              width: MediaQuery.of(context).size.width * 0.30,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.grey[00],
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      );
    }

    return Flexible(
      fit: FlexFit.loose,
      child: ListView.builder(
          itemCount: _routine.length,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return FlatButton(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => IndividualWorkoutIntro(
                            freeRoutine: _routine[index].name,
                            routineImage: _routine[index].image,
                            author: _routine[index].author,
                            routineTime: _routine[index].duration,
                            description: _routine[index].description,
                            objective: _routine[index].objectives,
                            equipment: _routine[index].equipment)));
              },
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: <Widget>[
                    ///Image
                    Container(
                      height: double.infinity,
                      width: MediaQuery.of(context).size.width * 0.35,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.grey[250],
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          image: DecorationImage(
                            image: NetworkImage(_routine[index].image),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: <BoxShadow>[
                            new BoxShadow(
                              color: Colors.white,
                              offset: new Offset(0.0, 3.0),
                              blurRadius: 5.0,
                            )
                          ]),
                    ),

                    ///Info
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ///Name
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Text(
                              _routine[index].name,
                              style: Theme.of(context).textTheme.title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          SizedBox(height: 5),

                          ///Intro
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            constraints: BoxConstraints(maxHeight: 100),
                            child: Text(
                              _routine[index]
                                  .objectives
                                  .toString()
                                  .replaceAll('[', '')
                                  .replaceAll(']', ''),
                              style: Theme.of(context).textTheme.body1,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),
                          Spacer(),

                          ///Time and Category
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Text(
                              _routine[index].duration +
                                  ' - ' +
                                  difficulty[_routine[index].userExperience],
                              style: Theme.of(context).textTheme.display2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
