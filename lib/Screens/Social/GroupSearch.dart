import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/groups.dart';
import 'package:personal_trainer/Models/posts.dart';
import 'package:personal_trainer/Screens/Social/GroupPage.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class GroupSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final _groupSearch = Provider.of<List<Groups>>(context);

    if (_groupSearch == null) {
      return SizedBox.shrink(child: Loading());
    } else if (_groupSearch.length == 0) {
      return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
          height: 100,
          child: Center(
            child: Text('Oops.. no se encontraron grupos con ese nombre'),
          ),
        ),
      );
    } 
    return Flexible(
      fit: FlexFit.loose,
      child: Container(
        child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 25.0,
              mainAxisSpacing: 30.0,
              childAspectRatio: 0.8,
            ),
            padding: EdgeInsets.only(top: 15, bottom: 20, left: 5, right: 5),
            itemCount: _groupSearch.length ?? 0,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MultiProvider(
                                providers: [
                                  StreamProvider<Groups>.value(
                                      value: DatabaseService().groupData(
                                          _groupSearch[index].groupName)),
                                  StreamProvider<List<Post>>.value(
                                      value: DatabaseService().groupFeed(
                                          _groupSearch[index].groupName)),
                                ],
                                child: GroupPage(groupName: _groupSearch[index].groupName),
                              )));
                },
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
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ///Image
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.grey[100],
                            child: ClipOval(
                              child: Container(
                                  height: 120,
                                  width: 120,
                                  child: Image.network(
                                      _groupSearch[index].groupImage,
                                      fit: BoxFit.cover)),
                            ),
                          ),
                          SizedBox(height: 20),

                          ///Name of Group
                          Container(
                            constraints: BoxConstraints(maxHeight: 35),
                            child: Text(
                              _groupSearch[index].groupName,
                              style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 5),

                          ///Members
                          Text(
                            NumberFormat.compact()
                                    .format(_groupSearch[index].memberCount)
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
    );
  }
}
