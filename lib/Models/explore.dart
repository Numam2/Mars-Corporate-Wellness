class ExploreRoutines {
  final String name;
  final String image;
  final String author;
  final String duration;
  final String description;
  final List equipment;
  final List objectives;
  final String firstWeek;
  final String firstDay;
  final DateTime dateUploaded;
  final List userGoals;
  final bool userSex;
  final int userExperience;

  ExploreRoutines(
      {this.name,
      this.image,
      this.author,
      this.duration,
      this.description,
      this.objectives,
      this.equipment,
      this.firstWeek,
      this.firstDay,
      this.dateUploaded,
      this.userGoals,
      this.userSex,
      this.userExperience,
      });
}

class ExploreWorkouts {
  final String name;
  final String image;
  final String author;
  final String duration;
  final String description;
  final List equipment;
  final List objectives;
  final DateTime dateUploaded;
  final List userGoals;
  final bool userSex;
  final int userExperience;

  ExploreWorkouts(
      {this.name,
      this.image,
      this.author,
      this.duration,
      this.description,
      this.objectives,
      this.equipment,
      this.dateUploaded,
      this.userGoals,
      this.userSex,
      this.userExperience,
      });
}
