import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/groups.dart';
import 'package:personal_trainer/Screens/Social/GroupSearch.dart';
import 'package:provider/provider.dart';

class PopularGroups extends StatefulWidget {

  @override
  _PopularGroupsState createState() => _PopularGroupsState();
}

class _PopularGroupsState extends State<PopularGroups> {

  String groupToSearch;
  var _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(        
            backgroundColor: Colors.white,          
            centerTitle: true,
            automaticallyImplyLeading: false,            
            leading: InkWell(
            onTap:() {Navigator.pop(context);},
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,),
            ),
            title: Text('Search Groups',
              style: Theme.of(context).textTheme.headline)            
          ),

      body: Container(
        padding: EdgeInsets.symmetric(horizontal:20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(top: 15, bottom: 10.0),
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                      borderRadius: BorderRadius.circular(25.0),
                      boxShadow: <BoxShadow>[
                        new BoxShadow(
                          color: Colors.grey,
                          offset: new Offset(0.0, 3.0),
                          blurRadius: 5.0,
                        )
                      ]
                    ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ///Icons Button
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20.0),
                        child: Icon(
                          Icons.search, color: Colors.grey, size: 26),
                      ),

                      ///Input Text
                      Container(
                        width: MediaQuery.of(context).size.width*0.5,
                        child: TextFormField(
                          style: GoogleFonts.montserrat(
                              color: Colors.black, fontSize: 14),
                          cursorColor: Colors.redAccent[700],
                          autofocus: false,
                          expands: false,
                          maxLines: null,
                          controller: _controller,
                          decoration: InputDecoration.collapsed(
                            hintText: "Buscar grupos...",
                            hintStyle: TextStyle(color: Theme.of(context).canvasColor),
                          ),
                          onChanged: (value) {
                            setState(() => groupToSearch = value);                          
                          },                        
                        ),
                  ),

                  Spacer(),

                  ///Cancel Button
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      child: Icon(Icons.close, color: Colors.black, size: 20),
                      onTap: () {
                        //DatabaseService().sendMessage(widget.docID, messageText);

                        setState(() {
                          _controller.clear();
                        });
                        
                      }),
                  )
                ],
              )),
            ),

            StreamProvider<List<Groups>>.value(
              value: DatabaseService().searchGroups(groupToSearch),
              child: GroupSearch()
            ),

        ]),
      ),
    );
  }
}