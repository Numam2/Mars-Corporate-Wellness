import 'package:flutter/material.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/messages.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Messages/SearchUserData.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:provider/provider.dart';

class SearchUserstoChat extends StatefulWidget {
  @override
  _SearchUserstoChatState createState() => _SearchUserstoChatState();
}

class _SearchUserstoChatState extends State<SearchUserstoChat> {
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserProfile>(context);
    final _users = Provider.of<List<UserProfile>>(context);

    if (_users == null){
      return Column(
        children:<Widget>[
          MessagesLoading(),
          MessagesLoading(),
          MessagesLoading()
        ]
      );
    } else if (_users.length == 0) {
      return GestureDetector(
        onTap: (){
          FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();}
        },
        child: Container(
          height: 100,
          child: Center(
            child: Text('Oops.. no se encontró ningun usuario con ese nombre'),
          ),
        ),
      );
    }

    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 20),
            itemCount: _users.length ?? 0,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return StreamProvider<List<SearchChatsList>>.value(
                value: DatabaseService().searchChatsList(_users[index].uid),
                child: SearchUserData(myUID: _user.uid, searchUser: _users[index])
              );
            }),
      ),
    );
  }
}
