class Recipes {
  String name;
  String image;
  String author;
  String intro;
  String time;
  String category;
  List directions;
  List tags;
  List ingredients;
  String recipeID;
  List likes;

  Recipes(
      {this.name,
      this.image,
      this.author,
      this.intro,
      this.time,
      this.category,
      this.directions,
      this.tags,
      this.ingredients,
      this.recipeID,
      this.likes});
}
