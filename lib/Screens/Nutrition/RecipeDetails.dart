import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';

class RecipeDetails extends StatefulWidget {
  final String user;
  final String name;
  final String description;
  final String author;
  final String time;
  final String category;
  final String image;
  final List ingredients;
  final List directions;
  final List tags;
  final String recipeID;
  final List likes;

  RecipeDetails(
      {this.user,
      this.name,
      this.description,
      this.author,
      this.time,
      this.category,
      this.image,
      this.ingredients,
      this.directions,
      this.tags,
      this.recipeID,
      this.likes});

  @override
  _RecipeDetailsState createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  
  bool savedRecipe;

  @override
  void initState() {
    if (widget.likes.contains(widget.user)) {
      savedRecipe = true;
    } else {
      savedRecipe = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(bottom:20.0),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ///Image
                  Container(
                    height: MediaQuery.of(context).size.height*0.4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.image),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.grey[800], BlendMode.hardLight)),
                    ),
                    child: Stack(
                      children: <Widget>[
                        ///Back Button
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0, left: 20),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(Icons.keyboard_arrow_left, color: Colors.white),
                            ),
                          ),
                        ),
                        ///Title
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:<Widget>[
                                Text(widget.name, style: Theme.of(context).textTheme.caption),
                                SizedBox(height:5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Por: ' + widget.author, 
                                      style: GoogleFonts.montserrat(fontWeight: FontWeight.w300, color: Colors.white, fontSize: 12),
                                    ),
                                    Spacer(),
                                    InkWell(
                                      onTap: (){

                                        if (savedRecipe){
                                          DatabaseService().unlikeRecipe(widget.recipeID);
                                          setState(() {                                          
                                            savedRecipe = false;
                                          });
                                        } else {
                                          DatabaseService().likeRecipe(widget.recipeID);
                                          setState(() {                                          
                                            savedRecipe = true;
                                          });
                                        } 
                                        
                                      },
                                      child: savedRecipe 
                                        ? Icon(CupertinoIcons.heart_solid, color: Colors.redAccent[700], size: 20)
                                        : Icon(CupertinoIcons.heart, color: Colors.white, size: 20)
                                    )
                                  ],
                                )
                              ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  ///Time and category
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:20.0, vertical:20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ///Time
                        Icon(Icons.watch_later, size: 15, color: Colors.black),
                        SizedBox(width:5),
                        Text(
                          widget.time,
                          style: Theme.of(context).textTheme.display2
                        ),
                        SizedBox(width:50),

                        ///Category
                        Icon(Icons.category, size: 15, color: Colors.black),
                        SizedBox(width:5),
                        Text(
                          widget.category,
                          style: Theme.of(context).textTheme.display2
                        ),

                        
                      ],
                    ),
                  ),
                  SizedBox(height: 10),

                  //Intro
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(widget.description,
                          style: Theme.of(context).textTheme.body1)),
                  SizedBox(height: 10),

                  ///Tags
                  Container(
                    height: 70,
                    padding: EdgeInsets.only(left: 20.0),
                    child: ListView.builder(
                      itemCount: widget.tags.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index){
                        if (index == 0){
                          return SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical:20.0, horizontal: 5),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal:15.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(25.0)),
                            child: Center(
                              child: Text(widget.tags[index],
                                  style: GoogleFonts.montserrat(fontWeight:FontWeight.w400, fontSize: 12, 
                                  color: Colors.white)
                              ),
                            )
                          ),
                        );
                      }
                    ),
                  ),
                  SizedBox(height: 10),

                  ///Ingredients
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Ingredientes',
                      style: Theme.of(context).textTheme.title
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: ListView.builder(
                        itemCount: widget.ingredients.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 8),
                            child: Container(
                              width: double.infinity,
                              child: Row(children: <Widget>[
                                //Icon
                                Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: <BoxShadow>[
                                      new BoxShadow(
                                        color: Colors.grey[350],
                                        offset: new Offset(0.0, 3.0),
                                        blurRadius: 5.0,
                                      )
                                    ]
                                  ),
                                  child: Icon(Icons.add,
                                      color: Colors.black,
                                      size: 15),
                                ),
                                SizedBox(width: 15.0),

                                ///Ingredientes
                                Container(
                                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.75),
                                  child: Text(widget.ingredients[index],
                                      style: GoogleFonts.montserrat(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black)),
                                ),
                              ]),
                            ),
                          );
                        }),
                  ),
                  SizedBox(height:30),

                  ///Preparation
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Preparación',
                      style: Theme.of(context).textTheme.title
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: ListView.builder(
                        itemCount: widget.directions.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 8),
                            child: Container(
                              width: double.infinity,
                              child: Row(children: <Widget>[
                                //Icon
                                Text((index+1).toString(),
                                  style: Theme.of(context).textTheme.title
                                ),
                                SizedBox(width: 15.0),

                                ///Objetivo
                                Container(
                                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.75),
                                  child: Text(widget.directions[index],
                                      style: GoogleFonts.montserrat(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black)),
                                ),
                              ]),
                            ),
                          );
                        }),
                  ),
                  SizedBox(height:15)

                ]),
          ),
        ),
      ),
    );
  }
}
