import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/posts.dart';
import 'package:personal_trainer/Screens/Social/ArticleDetails.dart';
import 'package:provider/provider.dart';

class FeedArticlesList extends StatelessWidget {
  final String organizationName;
  FeedArticlesList({this.organizationName});

  Widget articleTabs(List articleList, int index, BuildContext context) {
    return Padding(
      padding: (index == articleList.length - 1)
          ? const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10)
          : const EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
      child: InkWell(
        onTap: () {
          //Write to USER READS
          DatabaseService()
              .readArticle(organizationName, articleList[index].articleID);
          DatabaseService().recordOrganizationStats(organizationName, 'Article Reads');

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ArticleDetails(
                        title: articleList[index].title,
                        author: articleList[index].author,
                        image: articleList[index].image,
                        date: articleList[index].date,
                        content: articleList[index].content,
                      )));
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              boxShadow: <BoxShadow>[
                new BoxShadow(
                  color: Colors.grey[350],
                  offset: new Offset(0.0, 3.0),
                  blurRadius: 10.0,
                )
              ]),
          child: Column(children: [
            //Image
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(articleList[index].image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            //Text
            Container(
              height: 75,
              width: double.infinity,
              padding: EdgeInsets.all(8),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Title
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.8),
                      child: Text(articleList[index].title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 14)),
                    ),
                    SizedBox(height: 10),
                    //Tag
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.2),
                      child: Text(articleList[index].author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.display2),
                    ),
                  ]),
            ),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _article = Provider.of<List<Article>>(context);

    if (_article == null || _article.length == null) {
      return SizedBox();
    } else if (_article.length == 0) {
      return SizedBox();
    } else {
      return Container(
        height: MediaQuery.of(context).size.height * 0.4,
        child: ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: (_article.length > 5) ? 5 : _article.length,
            itemBuilder: (context, index) {
              List<Article> articleList = _article.reversed.toList();

              return articleTabs(articleList, index, context);
            }),
      );
    }
  }
}
