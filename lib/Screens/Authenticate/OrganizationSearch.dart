import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Models/organization.dart';
import 'package:personal_trainer/Screens/Authenticate/register.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:provider/provider.dart';

class OrganizationSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final _organizationSearch = Provider.of<List<Organization>>(context);

    if (_organizationSearch == null) {
      return SizedBox.shrink(child: Loading());
    } else if (_organizationSearch.length == 0) {
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
            child: Text('Oops.. no se encontraron organizaciones con ese nombre'),
          ),
        ),
      );
    } 
    return Flexible(
      fit: FlexFit.loose,
      child: Container(
        child: ListView.builder(
            shrinkWrap: true,            
            padding: EdgeInsets.only(top: 15),
            itemCount: _organizationSearch.length ?? 0,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Register(organization: _organizationSearch[index].organizationName, domain: _organizationSearch[index].domain)));
                  },
                  child: Container(
                    height: 70,
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
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                        _organizationSearch[index].logo,
                                        fit: BoxFit.cover)
                                  ),
                              ),
                            ),
                            SizedBox(width: 15),
                            ///Name of Group
                            Container(
                              constraints: BoxConstraints(maxWidth: 300),
                              child: Text(
                                _organizationSearch[index].organizationName,
                                style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ),                         
                          ]),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
