class Post {

  String postID;
  String ownerUID;
  DateTime date;
  List likes;
  String textContent;
  String media;
  String location;
  List<PostComments> comments;

  final String type;
  final String headline;
  final String subtitle;

  Post({this.postID, this.ownerUID, this.date, this.likes, this.textContent, this.media, this.location, this.comments, this.type, this.headline, this.subtitle});

}

class PostComments {
  
  String userID;
  String comment;
  DateTime time;

  PostComments({this.userID, this.comment, this.time});

}