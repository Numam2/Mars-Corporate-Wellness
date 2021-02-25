import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:personal_trainer/Models/posts.dart';

class ArticleDetails extends StatelessWidget {
  final String image;
  final String title;
  final String author;
  final DateTime date;
  final List<ArticleContent> content;

  ArticleDetails(
      {this.image, this.title, this.author, this.date, this.content});

  Widget contentFormatting(String text, String type, BuildContext context) {
    if (type == 'Text') {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          child: Text(
            text,
            style: GoogleFonts.montserrat(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
          ),
        ),
      );
    } else if (type == 'Subtitle') {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          child: Text(
            text,
            style: GoogleFonts.montserrat(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else if (type == 'Image') {
      return Padding(
          padding: EdgeInsets.all(20),
          child: Container(
            constraints: BoxConstraints(maxHeight: 400),
            width: double.infinity,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(image, fit: BoxFit.fitWidth)),
          ));
    } else {
      return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Image
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(image), fit: BoxFit.cover),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0, left: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white38,
                      ),
                      child:
                          Icon(Icons.keyboard_arrow_left, color: Colors.white)),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          //Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8),
              child: Text(
                title,
                style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          //Author
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8),
              child: Text(
                'Por: $author  |  ${DateFormat.yMd().format(date).toString()}',
                style: GoogleFonts.montserrat(
                    color: Colors.black45,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
          //Content
          Container(
            width: double.infinity,
            child: ListView.builder(
                itemCount: content.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  return contentFormatting(
                      content[i].text, content[i].type, context);
                }),
          ),
          SizedBox(height:35),
        ],
      )),
    ));
  }
}
