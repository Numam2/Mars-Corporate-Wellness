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

class Article {

  final String title;
  final String author;
  final List<ArticleContent> content;
  final DateTime date;
  final String image;
  final List userReads;
  final String articleID;

  Article({this.title, this.author, this.content, this.date, this.image, this.userReads, this.articleID});

}

class ArticleContent {

  final String text;
  final String type;

  ArticleContent({this.text, this.type});

}