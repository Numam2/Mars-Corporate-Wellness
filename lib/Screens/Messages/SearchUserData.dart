import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/messages.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Messages/ChatRoom.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:provider/provider.dart';

class SearchUserData extends StatelessWidget {

  final UserProfile myUserProfile;
  final UserProfile searchUser;

  SearchUserData({this.searchUser, this.myUserProfile});

  @override
  Widget build(BuildContext context) {

    final _searchUser = Provider.of<List<SearchChatsList>>(context);

    if (_searchUser == null){
      return MessagesLoading();
    }

    return InkWell(
        onTap: () async {

            ///// Create a certain Doc ID
            final String generateDocID = myUserProfile.uid + searchUser.uid;

            /// Create Chat Room based on that Doc ID
            await DatabaseService().createFirstChat(searchUser.uid, generateDocID);

            ///// Navigate to that chat room
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StreamProvider<ChatsList>.value(
                      value: DatabaseService().selectedChat(generateDocID),
                      child: ChatRoom(
                        myUID: myUserProfile.uid,
                        docID: generateDocID, 
                        profilePic: searchUser.profilePic, 
                        name: searchUser.name,
                        myUserProfile: myUserProfile,
                      ),
                    )));
        
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //User Image
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[100],
                child: ClipOval(
                  child: Container(
                      height: 60,
                      width: 60,
                      color: Colors.grey[200],
                      child: Image.network(searchUser.profilePic,
                          fit: BoxFit.cover)),
                ),
              ),
              SizedBox(width: 15),

              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      searchUser.name,
                      style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 3),
                    (searchUser.about == null || searchUser.about == '')
                        ? Text(
                            searchUser.name,
                            style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey[800]),
                          )
                        : Text(
                            searchUser.about,
                            style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey[800]),
                          ),
                  ]),

              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Text(
                  'Activo',
                  style: GoogleFonts.montserrat(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey),
                ),
              ),
            ],
          ),
        ));
  }
}
