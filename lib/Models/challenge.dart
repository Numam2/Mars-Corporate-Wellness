

class Challenge {

  final String description;
  final String lastChecked;
  final int currentDay;
  final int totalDays;
  final DateTime created;

  Challenge({this.description, this.lastChecked, this.currentDay, this.totalDays, this.created}); 

}

class PopularChallenges {
  
  final String description;
  final String image; 
  final int totalDays;
  final DateTime created;

  PopularChallenges({this.description, this.image, this.totalDays, this.created}); 

}