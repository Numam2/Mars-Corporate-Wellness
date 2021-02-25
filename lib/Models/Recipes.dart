class Recipes {
  final String name;
  final String image;
  final String author;
  final String intro;
  final String time;
  final String category;
  final List directions;
  final List tags;
  final List ingredients;
  final String recipeID;
  final List likes;
  DateTime dateUploaded;
  List userGoals;

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
      this.likes,
      this.dateUploaded,
      this.userGoals
      });
}
