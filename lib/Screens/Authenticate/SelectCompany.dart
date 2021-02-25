import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/organization.dart';
import 'package:personal_trainer/Screens/Authenticate/OrganizationSearch.dart';
import 'package:provider/provider.dart';

class SelectCompany extends StatefulWidget {
  @override
  _SelectCompanyState createState() => _SelectCompanyState();
}

class _SelectCompanyState extends State<SelectCompany> {

  String groupToSearch;
  var _controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(         
        body: Container(
         padding: EdgeInsets.symmetric(horizontal:20),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: <Widget>[
             SizedBox(height: 10),    
             //Go Back
             InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
             SizedBox(height: 20),             
             ////// Logo
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
                Container(
                  height: 70,
                  child: Image(image: AssetImage('Images/Brand/Blue Isologo.png'), height: 70)),
                ] 
              ),
              SizedBox(height:15),
              ////// First Text
              Container(
                child: Text("Selecciona tu organización",
                    style: GoogleFonts.montserrat(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              SizedBox(height:15),
             //Search Box
             Container(
               color: Colors.white,
               padding: const EdgeInsets.only(top: 15, bottom: 10.0),
               child: Container(
                 padding: EdgeInsets.symmetric(vertical:10),
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
                             hintText: "Buscar",
                             hintStyle: TextStyle(color: Theme.of(context).canvasColor),
                           ),
                           onChanged: (value) {
                             setState(() => groupToSearch = value.toLowerCase());                          
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
                         setState(() {
                           _controller.clear();
                         });
                         
                       }),
                   )
                 ],
               )),
             ),              
            //List of companies
             Container(
               child: StreamProvider<List<Organization>>.value(
                 value: DatabaseService().searchOrganizations(groupToSearch),
                 child: OrganizationSearch()
               ),
             ),

         ]),
          ),
      ),
    );
  }
}