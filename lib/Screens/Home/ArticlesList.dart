import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/posts.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Social/ArticleDetails.dart';
import 'package:provider/provider.dart';

class ArticlesList extends StatefulWidget {
  @override
  _ArticlesListState createState() => _ArticlesListState();
}

class _ArticlesListState extends State<ArticlesList> {
  @override
  Widget build(BuildContext context) {
    final _article = Provider.of<List<Article>>(context);
    final _user = Provider.of<UserProfile>(context);

    if (_article == null) {
      return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: double.infinity,
          color: Colors.grey[250]);
    } else if (_article.length == 0 || _article.lastIndexWhere((article) => !article.userReads.contains(_user.uid)) == -1) {
      return SizedBox();
    }
    return Container(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                //Image
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.network(_article.lastWhere((article) => !article.userReads.contains(_user.uid)).image, fit: BoxFit.cover),
                ),
                //Close Button
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, right: 20),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        DatabaseService().readArticle(
                          _user.organization, _article.lastWhere((article) => !article.userReads.contains(_user.uid)).articleID);
                        setState(() {});
                      },
                      child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[400],
                          ),
                          child: Icon(Icons.close, color: Colors.white)),
                    ),
                  ),
                ),
                //Title
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(200, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    padding: EdgeInsets.all(20.0),
                    child: Container(
                      width: double.infinity,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            //Text
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.8),
                              child: Text(
                                _article.lastWhere((article) => !article.userReads.contains(_user.uid)).title,
                                textAlign: TextAlign.start,
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(height: 10),
                            //Button
                            Container(
                              height: 35,
                              width: 150,
                              child: RaisedButton(
                                onPressed: () {
                                  //Write to USER READS
                                  DatabaseService().readArticle(
                                      _user.organization,
                                      _article.last.articleID);
                                  DatabaseService().recordOrganizationStats(_user.organization, 'Article Reads');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ArticleDetails(
                                                title: _article.lastWhere((article) => !article.userReads.contains(_user.uid)).title,
                                                author: _article.lastWhere((article) => !article.userReads.contains(_user.uid)).author,
                                                image: _article.lastWhere((article) => !article.userReads.contains(_user.uid)).image,
                                                date: _article.lastWhere((article) => !article.userReads.contains(_user.uid)).date,
                                                content: _article.lastWhere((article) => !article.userReads.contains(_user.uid)).content,
                                              )));
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                padding: EdgeInsets.all(0.0),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).accentColor,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "LEER MÁS",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
