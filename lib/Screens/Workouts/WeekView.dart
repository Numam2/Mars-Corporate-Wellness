import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/user.dart';
import 'package:personal_trainer/Models/weeks.dart';
import 'package:personal_trainer/Screens/Workouts/WeekDaysList.dart';
import 'package:provider/provider.dart';

class WeekView extends StatefulWidget {
  @override
  _WeekViewState createState() => _WeekViewState();
}

class _WeekViewState extends State<WeekView>
    with SingleTickerProviderStateMixin {
  
  String collection = 'Training Routine';

  /// Create list from Firestore based on number of weeks in workout
  List<int> weekTab = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

  TabController _tabController;
  int weekNo = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: weekTab.length);
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AppUser>(context);

    return StreamProvider<List<WeekDays>>.value(
      value: DatabaseService().weekDays(collection, user.uid, "Week $weekNo"),
        child: Scaffold(

          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text('My Plan', style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w300 ,color:Colors.white),),
            leading: InkWell(
              onTap: () {Navigator.pop(context);},
              child: Icon(
                Icons.keyboard_arrow_left
              ),
            ),
            centerTitle: true,
          ),

          body: Column(
          mainAxisAlignment: MainAxisAlignment.start, 
          children: <Widget>[
          ///Weeks Text
          Container(
            padding: EdgeInsets.fromLTRB(20.0, 25.0, 10.0, 15.0),
            width: double.infinity,
            //color: Colors.blue,
            child: Text("Week",
                style: GoogleFonts.montserrat(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
          ),

          ///Weeks Tab Design
          Padding(
            padding: const EdgeInsets.fromLTRB(25.0, 8.0, 25.0, 8.0),
            child: Container(
                //color: Colors.yellowAccent,
                child: SizedBox(
              height: 50,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: <BoxShadow>[
                      new BoxShadow(
                        color: Colors.black12,
                        offset: new Offset(0.0, 10.0),
                        blurRadius: 10.0,
                      ),
                    ]),
                child: TabBar(
                  onTap: (index) {
                    setState(() {});
                    weekNo = index + 1;
                    print(weekNo);
                  },
                  isScrollable: true,
                  unselectedLabelColor: Colors.grey,
                  labelColor: Colors.white,
                  labelStyle: GoogleFonts.montserrat(fontSize: 14.0),
                  controller: _tabController,
                  indicator: BoxDecoration(
                      color: Colors.redAccent[700],
                      borderRadius: BorderRadius.circular(25)
                    ),
                  tabs: List<Widget>.generate(weekTab.length, (int index) {
                    int tabNo = index + 1;
                    return Tab(text: "$tabNo");
                  }),
                ),
              ),
            )),
          ),

          ///Days Text
          Container(
            padding: EdgeInsets.fromLTRB(20.0, 25.0, 10.0, 15.0),
            width: double.infinity,
            //color: Colors.blue,

            child: Text("Day",
                style: GoogleFonts.montserrat(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: TabBarView(
                controller: _tabController,
                children: List<Widget>.generate(
                  weekTab.length,
                  (int index) {

                    return WeekDaysList(collection: collection, weekNo: "Week $weekNo", id: user.uid);
                  
                  },
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
