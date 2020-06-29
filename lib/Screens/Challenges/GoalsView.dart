import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart' as intl_local_date_data;
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/goals.dart';
import 'package:personal_trainer/Screens/Challenges/GoalDelete.dart';
import 'package:personal_trainer/Screens/Challenges/GoalUpdate.dart';
import 'package:personal_trainer/Screens/Challenges/GoalUpdate_Milestones.dart';
import 'package:personal_trainer/Screens/Challenges/Goal_Select_Type.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class GoalsView extends StatefulWidget {
  @override
  _GoalsViewState createState() => _GoalsViewState();
}

class _GoalsViewState extends State<GoalsView> {
  Future mainLocal(DateTime dateToFormat) async {
    await intl_local_date_data.initializeDateFormatting("es_VE", null);
    var format = new DateFormat.yMMMMd("es_VE").add_jm();
    var date = format.format(dateToFormat);
    return date;
  }

  @override
  Widget build(BuildContext context) {
    final _goal = Provider.of<List<Goals>>(context);

    if (_goal.length == 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Container(
          width: double.infinity,
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.45),                  
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Establece y trackea una meta significativa',
                        style: Theme.of(context).textTheme.display1,
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 35,
                        width: 150,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GoalSelectType()));
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          padding: EdgeInsets.all(0.0),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).accentColor,
                                  Theme.of(context).primaryColor
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "CREAR META",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ]),
                ),
              ),
              Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width*0.2,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: NetworkImage(
                        'https://firebasestorage.googleapis.com/v0/b/ludus-health-coach.appspot.com/o/App%20Images%2FIllustration%20Goals%20Start.jpg?alt=media&token=f6ec46c2-67ab-45d5-9eaf-4c8525454cd1'),
                    fit: BoxFit.cover,
                  )))
            ],
          ),
        ),
      );
    }

    return Container(
      //height: 170,
      width: double.infinity,
      child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _goal.length,
          itemBuilder: (context, index) {
            if(_goal[index].goalType == 'Weight'){
              ///If goal is to gain weight
              if(_goal[index].initialValue < _goal[index].targetValue){                
                if (DateTime.now().isBefore(_goal[index].dateTo) &&
                    _goal[index].currentValue.toDouble() >=
                        _goal[index].targetValue.toDouble()) {
                  //Completo
                  return Slidable(
                    actionPane: SlidableStrechActionPane(),
                    actionExtentRatio: 0.25,
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        color: Colors.white,
                        iconWidget: Icon(Icons.delete, color: Colors.black),
                        onTap: () {
                          return showDialog(
                              context: context,
                              builder: (context) {
                                return GoalDelete(
                                    goalDescription: _goal[index].description);
                              });
                        },
                      ),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Container(
                        width: double.infinity,
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
                        child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ///Header
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                  DateFormat.yMMMd()
                                                      .format(_goal[index].dateTo)
                                                      .toString(),
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500)),
                                              SizedBox(height: 5),
                                              Text('Completo',
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w300,
                                                      fontStyle: FontStyle.italic)),
                                            ]),
                                        Spacer(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.45),
                                              child: Text(_goal[index].description,
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500)),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                                _goal[index]
                                                        .currentValue
                                                        .toStringAsFixed(1) +
                                                    ' Kg' +
                                                    ' / ' +
                                                    _goal[index]
                                                        .targetValue
                                                        .toStringAsFixed(1) +
                                                    ' Kg',
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w300)),
                                          ],
                                        )
                                      ]),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  );
                } else if (_goal[index].dateTo.isBefore(DateTime.now())) {
                  //Failed
                  return Slidable(
                    actionPane: SlidableStrechActionPane(),
                    actionExtentRatio: 0.25,
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        color: Colors.white,
                        iconWidget: Icon(Icons.delete, color: Colors.black),
                        onTap: () {
                          return showDialog(
                              context: context,
                              builder: (context) {
                                return GoalDelete(
                                    goalDescription: _goal[index].description);
                              });
                        },
                      ),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Container(
                        width: double.infinity,
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
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ///Header
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                  DateFormat.yMMMd()
                                                      .format(_goal[index].dateTo)
                                                      .toString(),
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500)),
                                              SizedBox(height: 5),
                                              Text('Fallado',
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w300,
                                                      fontStyle: FontStyle.italic)),
                                            ]),
                                        Spacer(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.45),
                                              child: Text(_goal[index].description,
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500)),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                                _goal[index]
                                                        .currentValue
                                                        .toStringAsFixed(1) +
                                                    ' Kg' +
                                                    ' / ' +
                                                    _goal[index]
                                                        .targetValue
                                                        .toStringAsFixed(1) +
                                                    ' Kg',
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w300)),
                                          ],
                                        )
                                      ]),
                                ),
                                SizedBox(height: 10),

                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 35.0,
                                    child: RaisedButton(
                                      onPressed: () {
                                        DatabaseService()
                                            .deleteGoal(_goal[index].description);
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25)),
                                      padding: EdgeInsets.all(0.0),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Theme.of(context).accentColor,
                                              Theme.of(context).primaryColor
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        child: Container(
                                          constraints: BoxConstraints(
                                              maxWidth: 200.0, minHeight: 50.0),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "BORRAR",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.montserrat(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  );
                } else {
                  //In progress
                  return Slidable(
                    actionPane: SlidableStrechActionPane(),
                    actionExtentRatio: 0.25,
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        color: Colors.white,
                        iconWidget: Icon(Icons.delete, color: Colors.black),
                        onTap: () {
                          return showDialog(
                              context: context,
                              builder: (context) {
                                return GoalDelete(
                                    goalDescription: _goal[index].description);
                              });
                        },
                      ),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Container(
                        width: double.infinity,
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
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ///Header
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                  DateFormat.yMMMd()
                                                      .format(_goal[index].dateTo)
                                                      .toString(),
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500)),
                                              SizedBox(height: 5),
                                              Text(
                                                  'En progreso' +
                                                      ' ' +
                                                      (((_goal[index].currentValue-_goal[index].initialValue) / (_goal[index].targetValue -_goal[index].initialValue))* 100)
                                                          .round()
                                                          .toString() +
                                                      '%',
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w300,
                                                      fontStyle: FontStyle.italic)),
                                            ]),
                                        Spacer(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.45),
                                              child: Text(_goal[index].description,
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500)),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                                _goal[index]
                                                        .currentValue
                                                        .toStringAsFixed(1) +
                                                    ' Kg / ' +
                                                    _goal[index]
                                                        .targetValue
                                                        .toStringAsFixed(1) +
                                                    ' Kg',
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w300)),
                                          ],
                                        )
                                      ]),
                                ),
                                SizedBox(height: 10),

                                ///Update button
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 35.0,
                                    child: RaisedButton(
                                      onPressed: () {

                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.white,
                                          isScrollControlled: true,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                                          ),
                                          builder: (context) {
                                            return Wrap(
                                              children:<Widget>[
                                                GoalUpdate(goal: _goal[index], loseWeight: false, currentVal: _goal[index].currentValue)
                                              ]);
                                          });

                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25)),
                                      padding: EdgeInsets.all(0.0),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Theme.of(context).accentColor,
                                              Theme.of(context).primaryColor
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        child: Container(
                                          constraints: BoxConstraints(
                                              maxWidth: 200.0, minHeight: 50.0),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "ACTUALIZAR PROGRESO",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.montserrat(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  );
                }
              ///If goal is to lose weight
              } else {
                if (DateTime.now().isBefore(_goal[index].dateTo) &&
                    _goal[index].currentValue.toDouble() <=
                        _goal[index].targetValue.toDouble()) {
                  //Completo
                  return Slidable(
                    actionPane: SlidableStrechActionPane(),
                    actionExtentRatio: 0.25,
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        color: Colors.white,
                        iconWidget: Icon(Icons.delete, color: Colors.black),
                        onTap: () {
                          return showDialog(
                              context: context,
                              builder: (context) {
                                return GoalDelete(
                                    goalDescription: _goal[index].description);
                              });
                        },
                      ),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Container(
                        width: double.infinity,
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
                        child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ///Header
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                  DateFormat.yMMMd()
                                                      .format(_goal[index].dateTo)
                                                      .toString(),
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500)),
                                              SizedBox(height: 5),
                                              Text('Completo',
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w300,
                                                      fontStyle: FontStyle.italic)),
                                            ]),
                                        Spacer(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.45),
                                              child: Text(_goal[index].description,
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500)),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                                _goal[index]
                                                        .currentValue
                                                        .toStringAsFixed(1) +
                                                    ' Kg' +
                                                    ' / ' +
                                                    _goal[index]
                                                        .targetValue
                                                        .toStringAsFixed(1) +
                                                    ' Kg',
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w300)),
                                          ],
                                        )
                                      ]),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  );
                } else if (_goal[index].dateTo.isBefore(DateTime.now())) {
                  //Failed
                  return Slidable(
                    actionPane: SlidableStrechActionPane(),
                    actionExtentRatio: 0.25,
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        color: Colors.white,
                        iconWidget: Icon(Icons.delete, color: Colors.black),
                        onTap: () {
                          return showDialog(
                              context: context,
                              builder: (context) {
                                return GoalDelete(
                                    goalDescription: _goal[index].description);
                              });
                        },
                      ),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Container(
                        width: double.infinity,
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
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ///Header
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                  DateFormat.yMMMd()
                                                      .format(_goal[index].dateTo)
                                                      .toString(),
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500)),
                                              SizedBox(height: 5),
                                              Text('Fallado',
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w300,
                                                      fontStyle: FontStyle.italic)),
                                            ]),
                                        Spacer(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.45),
                                              child: Text(_goal[index].description,
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500)),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                                _goal[index]
                                                        .currentValue
                                                        .toStringAsFixed(1) +
                                                    ' Kg' +
                                                    ' / ' +
                                                    _goal[index]
                                                        .targetValue
                                                        .toStringAsFixed(1) +
                                                    ' Kg',
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w300)),
                                          ],
                                        )
                                      ]),
                                ),
                                SizedBox(height: 10),

                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 35.0,
                                    child: RaisedButton(
                                      onPressed: () {
                                        DatabaseService()
                                            .deleteGoal(_goal[index].description);
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25)),
                                      padding: EdgeInsets.all(0.0),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Theme.of(context).accentColor,
                                              Theme.of(context).primaryColor
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        child: Container(
                                          constraints: BoxConstraints(
                                              maxWidth: 200.0, minHeight: 50.0),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "BORRAR",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.montserrat(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  );
                } else {
                  //In progress
                  return Slidable(
                    actionPane: SlidableStrechActionPane(),
                    actionExtentRatio: 0.25,
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        color: Colors.white,
                        iconWidget: Icon(Icons.delete, color: Colors.black),
                        onTap: () {
                          return showDialog(
                              context: context,
                              builder: (context) {
                                return GoalDelete(
                                    goalDescription: _goal[index].description);
                              });
                        },
                      ),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Container(
                        width: double.infinity,
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
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ///Header
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                  DateFormat.yMMMd()
                                                      .format(_goal[index].dateTo)
                                                      .toString(),
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500)),
                                              SizedBox(height: 5),
                                              Text(
                                                  'En progreso' +
                                                      ' ' +
                                                      (((_goal[index].initialValue -_goal[index].currentValue) / (_goal[index].initialValue -_goal[index].targetValue)) * 100)
                                                          .round()
                                                          .toString() +
                                                      '%',
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w300,
                                                      fontStyle: FontStyle.italic)),
                                            ]),
                                        Spacer(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.45),
                                              child: Text(_goal[index].description,
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500)),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                                _goal[index]
                                                        .currentValue
                                                        .toStringAsFixed(1) +
                                                    ' Kg / ' +
                                                    _goal[index]
                                                        .targetValue
                                                        .toStringAsFixed(1) +
                                                    ' Kg',
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w300)),
                                          ],
                                        )
                                      ]),
                                ),
                                SizedBox(height: 10),

                                ///Update button
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 35.0,
                                    child: RaisedButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.white,
                                          isScrollControlled: true,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                                          ),
                                          builder: (context) {
                                            return Wrap(
                                              children:<Widget>[
                                                GoalUpdate(goal: _goal[index], loseWeight: false, currentVal: _goal[index].currentValue)
                                              ]);
                                          });
                                        // showDialog(
                                        //     context: context,
                                        //     builder: (context) {
                                        //       return GoalUpdate(goal: _goal[index]);
                                        //     });
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25)),
                                      padding: EdgeInsets.all(0.0),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Theme.of(context).accentColor,
                                              Theme.of(context).primaryColor
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        child: Container(
                                          constraints: BoxConstraints(
                                              maxWidth: 200.0, minHeight: 50.0),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "ACTUALIZAR PROGRESO",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.montserrat(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  );
                }
                

              }

            ///If type of Goal is Non-Weight
            } else {
              if (DateTime.now().isBefore(_goal[index].dateTo) &&
                  _goal[index].currentValue.toDouble() >=
                      _goal[index].targetValue.toDouble()) {
                //Completo
                return Slidable(
                  actionPane: SlidableStrechActionPane(),
                  actionExtentRatio: 0.25,
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      color: Colors.white,
                      iconWidget: Icon(Icons.delete, color: Colors.black),
                      onTap: () {
                        return showDialog(
                            context: context,
                            builder: (context) {
                              return GoalDelete(
                                  goalDescription: _goal[index].description);
                            });
                      },
                    ),
                  ],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Container(
                      width: double.infinity,
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
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ///Header
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                                DateFormat.yMMMd()
                                                    .format(_goal[index].dateTo)
                                                    .toString(),
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500)),
                                            SizedBox(height: 5),
                                            Text('Completo',
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w300,
                                                    fontStyle: FontStyle.italic)),
                                          ]),
                                      Spacer(),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.45),
                                            child: Text(_goal[index].description,
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500)),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                              _goal[index]
                                                      .currentValue
                                                      .toStringAsFixed(1) +
                                                  ' / ' +
                                                  _goal[index]
                                                      .targetValue
                                                      .toStringAsFixed(1),
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w300)),
                                        ],
                                      )
                                    ]),
                              ),
                            ]),
                      ),
                    ),
                  ),
                );
              } else if (_goal[index].dateTo.isBefore(DateTime.now())) {
                //Failed
                return Slidable(
                  actionPane: SlidableStrechActionPane(),
                  actionExtentRatio: 0.25,
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      color: Colors.white,
                      iconWidget: Icon(Icons.delete, color: Colors.black),
                      onTap: () {
                        return showDialog(
                            context: context,
                            builder: (context) {
                              return GoalDelete(
                                  goalDescription: _goal[index].description);
                            });
                      },
                    ),
                  ],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Container(
                      width: double.infinity,
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
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ///Header
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                                DateFormat.yMMMd()
                                                    .format(_goal[index].dateTo)
                                                    .toString(),
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500)),
                                            SizedBox(height: 5),
                                            Text('Fallado',
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w300,
                                                    fontStyle: FontStyle.italic)),
                                          ]),
                                      Spacer(),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.45),
                                            child: Text(_goal[index].description,
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500)),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                              _goal[index]
                                                      .currentValue
                                                      .toStringAsFixed(1) +
                                                  ' / ' +
                                                  _goal[index]
                                                      .targetValue
                                                      .round()
                                                      .toStringAsFixed(1),
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w300)),
                                        ],
                                      )
                                    ]),
                              ),
                              SizedBox(height: 10),

                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  height: 35.0,
                                  child: RaisedButton(
                                    onPressed: () {
                                      DatabaseService()
                                          .deleteGoal(_goal[index].description);
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25)),
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Theme.of(context).accentColor,
                                            Theme.of(context).primaryColor
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 200.0, minHeight: 50.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "BORRAR",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                );
              } else {
                //In progress
                return Slidable(
                  actionPane: SlidableStrechActionPane(),
                  actionExtentRatio: 0.25,
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      color: Colors.white,
                      iconWidget: Icon(Icons.delete, color: Colors.black),
                      onTap: () {
                        return showDialog(
                            context: context,
                            builder: (context) {
                              return GoalDelete(
                                  goalDescription: _goal[index].description);
                            });
                      },
                    ),
                  ],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Container(
                      width: double.infinity,
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
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ///Header
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                                DateFormat.yMMMd()
                                                    .format(_goal[index].dateTo)
                                                    .toString(),
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500)),
                                            SizedBox(height: 5),
                                            Text(
                                                'En progreso' +
                                                    ' ' +
                                                    ((_goal[index].currentValue /
                                                                _goal[index]
                                                                    .targetValue) *
                                                            100)
                                                        .round()
                                                        .toString() +
                                                    '%',
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w300,
                                                    fontStyle: FontStyle.italic)),
                                          ]),
                                      Spacer(),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.45),
                                            child: Text(_goal[index].description,
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500)),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                              (_goal[index]
                                                      .currentValue).round()
                                                      .toString() +
                                                  ' / ' +
                                                  (_goal[index]
                                                      .targetValue).round()
                                                      .toString(),
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w300)),
                                        ],
                                      )
                                    ]),
                              ),
                              SizedBox(height: 10),

                              ///Update button
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  height: 35.0,
                                  child: RaisedButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.white,
                                          isScrollControlled: true,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                                          ),
                                          builder: (context) {
                                            return Wrap(
                                              children:<Widget>[
                                                GoalUpdateMilestones(goal: _goal[index])
                                              ]);
                                          });
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25)),
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Theme.of(context).accentColor,
                                            Theme.of(context).primaryColor
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 200.0, minHeight: 50.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "ACTUALIZAR PROGRESO",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                );
              }
            }
          }),
    );
  }
}
