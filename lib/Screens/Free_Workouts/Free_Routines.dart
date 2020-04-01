import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_trainer/Screens/Workouts/DayPage.dart';
import 'package:personal_trainer/Shared/Loading.dart';

class FreeRoutineView extends StatefulWidget {

  final String freeRoutine;
  FreeRoutineView ({Key key, this.freeRoutine}) : super(key:key);

  @override
  _FreeRoutineViewState createState() => _FreeRoutineViewState();
}

class _FreeRoutineViewState extends State<FreeRoutineView> with SingleTickerProviderStateMixin {

  /// Create list from Firestore based on number of weeks in workout
  List<int> weekTab = [1,2,3,4];

  TabController _tabController;
  int weekNo = 1;

   //////// Create a future that retrieves Firestore data for Weeks collection
  Future getDays() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("Free Routines").document(widget.freeRoutine).collection("Week $weekNo").getDocuments(); //'dsYJLfLsvGgMVEfWe18RnNa2VuX2'    
    return qn.documents;
  }

  /////// Create a function to navigate into further details for every document printed
  navigatetoDetail(DocumentSnapshot day){
    Navigator.push(context, MaterialPageRoute(builder: (context) => DayDetail(day: day)));
  }

  @override
  void initState() {
    super.initState();
    //_tabController = TabController(vsync: this, length:12);
    _tabController = TabController(vsync: this, length: weekTab.length);
  }

  void _goBack() async {
    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(

        appBar: AppBar(
                  backgroundColor: Colors.black,
                  title: Text(widget.freeRoutine),
                  leading: InkWell(
                        onTap: _goBack,
                        child: Icon(
                          Icons.keyboard_arrow_left
                        ),
                      ),
                  centerTitle: true,
              ),

        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

            Container(
              padding: EdgeInsets.fromLTRB(20.0, 25.0, 10.0, 15.0),
              width: double.infinity,            
              //color: Colors.blue,
              child: Text(
                      "Week",
                      style: TextStyle(
                        fontSize: 30.0, fontFamily: "Roboto", fontWeight: FontWeight.bold, color: Colors.black
                      )
                ),
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
              labelStyle: TextStyle(fontSize: 14.0),
              controller: _tabController,
              indicator: BoxDecoration(
                  color: Colors.redAccent[700],
                  borderRadius: BorderRadius.circular(25)
                  // BorderRadius.only(
                  //   topRight: Radius.circular(12),
                  //   bottomLeft: Radius.circular(12),
                  //   bottomRight: Radius.circular(12),
                  //   )
                  ),
              tabs: List<Widget>.generate(weekTab.length, (int index) {
                int tabNo = index + 1;
                return Tab(text: "$tabNo");
              }),
            ),
          ),
        )),
      ),

            Container(
              padding: EdgeInsets.fromLTRB(20.0, 25.0, 10.0, 15.0),
              width: double.infinity,
              //color: Colors.blue,            

              child: Text(
                      "Day",
                      style: TextStyle(
                        fontSize: 30.0, fontFamily: "Roboto", fontWeight: FontWeight.bold, color: Colors.black
                      )
                ),
              ),

          Expanded(
            child: Padding(
                padding: const EdgeInsets.only(top: 10.0),              
                child:
                TabBarView(
                  controller: _tabController,                
                  children:                 

                    List<Widget>.generate(weekTab.length, (int index){
                      print(weekNo);

                      return

                      Container(
                        height: double.infinity,
                        child: FutureBuilder(
                          future: getDays(),
                          builder: (context,snapshot){

                          ////handle wait time for the Future with connection state
                          if (snapshot.connectionState == ConnectionState.waiting){
                            return Center(
                              child: Loading()
                              );
                    
                            ///If the week has not been created, return a message
                            } else if (snapshot.data.length == 0) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(50.0),
                                  child: 
                                  Text(
                                    "Oops!... Apparently the daily routines for this week are not yet available",
                                    textAlign: TextAlign.center),
                                  )
                                );

                            ///Perform if there is data to show
                            } else {
                              return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (_,index){
                    
                                  return Padding(
                                    padding: EdgeInsets.fromLTRB(20,5,20,5),
                                    child: Container(
                                      //width: double.infinity,
                                      decoration: BoxDecoration(
                                      //border: Border.fromBorderSide(BorderSide(color:Colors.grey, width: 0.5)),
                                      shape: BoxShape.rectangle,
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.0),
                                        boxShadow: <BoxShadow> [
                                          new BoxShadow(
                                            color: Colors.black12,
                                            offset: new Offset(0.0, 10.0),
                                            blurRadius: 10.0,
                                          )
                                        ]
                                      ),
                                      // margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
                                      child: InkWell(
                                        onTap: () => navigatetoDetail(
                                            snapshot.data[index]),
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(25,15,40,10),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                ///Number of week
                                                Container(
                                                  child: Text(
                                                    snapshot.data[index].data["Day"],
                                                    style: TextStyle(fontSize: 16, )
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                ///Body Part
                                                Row(
                                                  children:<Widget>[
                                                    Container(
                                                       height: 30,
                                                        // padding: EdgeInsets.fromLTRB(
                                                        //     12, 8, 12, 8),
                                                        // decoration: BoxDecoration(
                                                        //     color: Colors.black87,
                                                        //     borderRadius:
                                                        //         BorderRadius.circular(25)),                                                                    
                                                        child: Text(
                                                          snapshot.data[index]
                                                              .data["Body part"],
                                                          textAlign: TextAlign.start,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 8),
                                                      ///Focus
                                                      Container(
                                                        height: 30,
                                                        // padding: EdgeInsets.fromLTRB(
                                                        //     12, 8, 12, 8),
                                                        // decoration: BoxDecoration(
                                                        //     color: Colors.black54,
                                                        //     borderRadius:
                                                        //         BorderRadius.circular(25)),
                                                        child: Text(
                                                          snapshot.data[index]
                                                              .data["Focus"],
                                                          textAlign: TextAlign.start,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14, 
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),

                                                  ]
                                                ),                                                                                              
                                              ],
                                            ),

                                             Spacer(),

                                                ///Time

                                                Text(
                                                  snapshot
                                                      .data[index].data["Time"],
                                                  style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 12,
                                                    //fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                          ]),
                                        ),
                                      ),
                                    ));
                      
                                  });
                                }
                              }
                            ),

                      );
                    },
                  ),
              ),
            ),
          ),
        ]
    ),
      );
  }
}

