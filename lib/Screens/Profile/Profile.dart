import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/auth.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Profile/EditProfile.dart';
import 'package:personal_trainer/Screens/Profile/ProfileContent.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:personal_trainer/main.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {

  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    final _profile = Provider.of<UserProfile>(context);

    if(_profile == null){
      return Center(
        child: Loading(),
      );
    }

    return Scaffold(
      appBar: AppBar(        
        backgroundColor: Colors.white,          
        centerTitle: true,
        title: Text('Perfil',
          style: Theme.of(context).textTheme.headline),
        leading: Container(
          padding: EdgeInsets.symmetric(horizontal:8),
          height: 10,
          child: Image(image: AssetImage('Images/Brand/Blue Isologo.png'), height: 10), //Images/Brand/Blue Isologo.png
        ),
        actions:<Widget>[
          Builder(
            builder:(context) => InkWell(
              onTap: (){
                Scaffold.of(context).openEndDrawer();
              },
              child: Container(width: 60, height: double.infinity, child: Icon(Icons.settings, color: Colors.black, size:20)),
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:<Widget>[
                
                // Picture
                SizedBox(height:20),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[100],
                  child: ClipOval(
                    child: Container(
                      height: 100,
                      width: 100,
                      child: Image.network(_profile.profilePic,
                        fit: BoxFit.cover)),
                    ),
                ),
                SizedBox(height:20),
                Text(
                  _profile.name,
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.white, 
                  ),
                ),
                SizedBox(height:70),

                //Edit profile
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditProfile(profile: _profile)));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    child: Row(
                      children:<Widget>[
                        Icon(Icons.person, color: Colors.white, size: 18),
                        SizedBox(width:20),
                        Text(
                          'Editar perfil',
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            color: Colors.white, 
                          ),
                        ),
                      ] 
                    ),
                  ),
                ),

                // //Invite a Friend
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    child: Row(
                      children:<Widget>[
                        Icon(Icons.group_add, color: Colors.white, size: 18),
                        SizedBox(width:20),
                        Text(
                          'Invita a un amigo',
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            color: Colors.white, 
                          ),
                        ),
                      ] 
                    ),
                  ),
                ),

                // //Terms and Conditions
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    child: Row(
                      children:<Widget>[
                        Icon(Icons.library_books, color: Colors.white, size: 18),
                        SizedBox(width:20),
                        Text(
                          'Terminos y condiciones',
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            color: Colors.white, 
                          ),
                        ),
                      ] 
                    ),
                  ),
                ),

                // //Sign Out
                GestureDetector(
                  onTap: () async {
                    await _auth.signOut();
                    Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MyApp(signedOut: true)));
                    
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    child: Row(
                      children:<Widget>[
                        Icon(Icons.exit_to_app, color: Colors.white, size: 18),
                        SizedBox(width:20),
                        Text(
                          'Cerrar Sesión',
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            color: Colors.white, 
                          ),
                        ),
                      ] 
                    ),
                  ),
                ),

              ]
            ),
          ),
        )
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: ProfileContent())),
    );
  }
}
