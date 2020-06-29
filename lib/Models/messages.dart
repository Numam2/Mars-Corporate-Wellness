
class ChatsList {

  final List users;
  final String docID;
  final DateTime lastMessageTime;
  final List<UserReads> userReads;

  ChatsList ({this.users, this.docID, this.lastMessageTime, this.userReads});

}

class UserReads{

  final String user;
  final DateTime lastChecked;

  UserReads({this.user, this.lastChecked});

}

class SearchChatsList {

  final List users;
  final String docID;

  SearchChatsList ({this.users, this.docID});

}

class Messages {

  final String sender;
  final String text;
  final DateTime time;
  final String image;
  final String docID;

  final String type;
  final String headline;
  final String subtitle;

  Messages({this.sender, this.text, this.time, this.image, this.docID, this.type, this.headline, this.subtitle});

}