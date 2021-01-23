import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/groups.dart';
import 'package:personal_trainer/Models/posts.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Social/CreateGroup.dart';
import 'package:personal_trainer/Screens/Social/GroupNotifications.dart';
import 'package:personal_trainer/Screens/Social/GroupPage.dart';
import 'package:personal_trainer/Screens/Social/PopularGroups.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:provider/provider.dart';

class MyGroups extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _myGroup = Provider.of<List<Groups>>(context);
    final _notification = Provider.of<GroupNotificationList>(context);

    if (_myGroup == null || _notification == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: InkWell(
              onTap: () {},
              child: Container(
                height: 50,
                width: 60,
                child: Center(
                  child: Align(
                      alignment: Alignment.center,
                      child:
                          Icon(Icons.notifications_none, color: Colors.black)),
                ),
              )),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Container(
              width: double.infinity,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(children: <Widget>[
                      Text("Mis Grupos",
                          style: Theme.of(context).textTheme.title),
                      Spacer(),
                      IconButton(
                          icon: Icon(Icons.search, color: Colors.black),
                          onPressed: () {}),
                    ]),
                    SizedBox(height: 20),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Container(
                        width: double.infinity,
                        child: GridView.builder(
                            padding:
                                EdgeInsets.only(bottom: 20, left: 5, right: 5),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 25.0,
                              mainAxisSpacing: 30.0,
                              childAspectRatio: 0.8,
                            ),
                            shrinkWrap: true,
                            itemCount: 4,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {},
                                child: Container(
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
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          ///Image
                                          CircleAvatar(
                                            radius: 35,
                                            backgroundColor: Colors.grey[100],
                                            child: ClipOval(
                                              child: Container(
                                                height: 120,
                                                width: 120,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20),

                                          ///Name of Group
                                          Container(
                                            width: 70,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25)),
                                              color: Colors.grey[200],
                                            ),
                                          ),
                                          SizedBox(height: 5),

                                          ///Members
                                          Container(
                                            width: 50,
                                            height: 15,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25)),
                                              color: Colors.grey[100],
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                        ]),
                                  ),
                                ),
                              );
                            }),
                      ),
                    )
                  ]),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateGroup()));
            },
            child: Container(
              height: 50,
              width: 60,
              child: Center(
                child: Text('Crear',
                    style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor)),
              ),
            ),
          ),
        ],
        leading: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GroupNotificationPage()));
            },
            child: (_notification.groupNotifications.length > 0)
                ? Container(
                    height: 50,
                    width: 60,
                    child: Center(
                      child: Stack(children: <Widget>[
                        Align(
                            alignment: Alignment.center,
                            child: Icon(Icons.notifications_none,
                                color: Colors.black)),
                        Align(
                          alignment: Alignment(0.25, -0.4),
                          child: Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ]),
                    ),
                  )
                : Container(
                    height: 50,
                    width: 60,
                    child: Center(
                      child: Align(
                          alignment: Alignment.center,
                          child: Icon(Icons.notifications_none,
                              color: Colors.black)),
                    ),
                  )),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Container(
            width: double.infinity,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children: <Widget>[
                    Text("Mis Grupos",
                        style: Theme.of(context).textTheme.title),
                    Spacer(),
                    IconButton(
                        icon: Icon(Icons.search, color: Colors.black),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PopularGroups()));
                        }),
                  ]),
                  SizedBox(height: 20),
                  !(_myGroup.length == 0)
                      ? Flexible(                        
                          fit: FlexFit.loose,
                          child: Container(
                            width: double.infinity,
                            child: GridView.builder(
                                padding: EdgeInsets.only(
                                    bottom: 20, left: 5, right: 5),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 25.0,
                                  mainAxisSpacing: 30.0,
                                  childAspectRatio: 0.8,
                                ),
                                shrinkWrap: true,
                                itemCount: _myGroup.length ?? 0,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MultiProvider(
                                                    providers: [
                                                      StreamProvider<
                                                              Groups>.value(
                                                          value: DatabaseService()
                                                              .groupData(_myGroup[
                                                                      index]
                                                                  .groupName)),
                                                      StreamProvider<
                                                              List<Post>>.value(
                                                          value: DatabaseService()
                                                              .groupFeed(_myGroup[
                                                                      index]
                                                                  .groupName)),
                                                    ],
                                                    child: GroupPage(
                                                        groupName:
                                                            _myGroup[index]
                                                                .groupName),
                                                  )));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          boxShadow: <BoxShadow>[
                                            new BoxShadow(
                                              color: Colors.grey[350],
                                              offset: new Offset(0.0, 3.0),
                                              blurRadius: 5.0,
                                            )
                                          ]),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 15),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              ///Image
                                              CircleAvatar(
                                                radius: 35,
                                                backgroundColor:
                                                    Colors.grey[100],
                                                child: ClipOval(
                                                  child: Container(
                                                      height: 120,
                                                      width: 120,
                                                      child: Image.network(
                                                          _myGroup[index]
                                                              .groupImage,
                                                          fit: BoxFit.cover)),
                                                ),
                                              ),
                                              SizedBox(height: 20),

                                              ///Name of Group
                                              Text(
                                                _myGroup[index].groupName,
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: 5),

                                              ///Members
                                              Text(
                                                NumberFormat.compact()
                                                        .format(_myGroup[index]
                                                            .memberCount)
                                                        .toString() +
                                                    ' miembros',
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.black),
                                              ),
                                            ]),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        )
                      /// if user has no groups yet
                      : Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          width: double.infinity,
                          child: Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  /// Message Icon
                                  Icon(Icons.search,
                                      color: Theme.of(context).canvasColor,
                                      size: 40),

                                  ///Greetings Text
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        30, 20, 30, 5),
                                    child: Text(
                                      "¿Aun no eres parte de ningun grupo?",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 30),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                  ///Greetings Text
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        30, 15, 30, 5),
                                    child: Text(
                                      "Puedes crear un grupo privado con tus amigos o puedes unirte a algun grupo existente",
                                      style: Theme.of(context).textTheme.body1,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 15),

                                  /// Button
                                  Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          ///Chat with Mars Coach
                                          Container(
                                            height: 35.0,
                                            child: RaisedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PopularGroups()));
                                              },
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25)),
                                              padding: EdgeInsets.all(0.0),
                                              child: Ink(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Theme.of(context)
                                                          .accentColor,
                                                      Theme.of(context)
                                                          .primaryColor
                                                    ],
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                ),
                                                child: Container(
                                                  constraints: BoxConstraints(
                                                      maxWidth: 200.0,
                                                      minHeight: 50.0),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "BUSCAR",
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Container(
                                          //   width: 150,
                                          //   child: RaisedButton(
                                          //     color: Theme.of(context).primaryColor,
                                          //     child: Text(
                                          //       "Buscar",
                                          //       style: GoogleFonts.montserrat(
                                          //         color: Colors.white),
                                          //       ),
                                          //       shape: RoundedRectangleBorder(
                                          //         borderRadius: BorderRadius.circular(20),
                                          //       ),
                                          //       onPressed: () {
                                          //         Navigator.push(
                                          //           context, MaterialPageRoute(builder: (context) => PopularGroups()));
                                          //       }
                                          //   ),
                                          // ),
                                        ],
                                      )),
                                ]),
                          ),
                        ),
                ]),
          ),
        ),
      ),
    );
  }
}
