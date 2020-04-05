

class Challenge {

  final String description;
  final String lastChecked;
  final int currentDay;
  final int totalDays;

  Challenge({this.description, this.lastChecked, this.currentDay, this.totalDays}); 

}

class PopularChallenges {
  
  final String description;
  final String image; 
  final int totalDays;

  PopularChallenges({this.description, this.image, this.totalDays}); 

}