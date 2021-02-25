

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

class ChallengeContest {

  final String challengeID;
  final String title;
  final String image;
  final String description;
  final DateTime dateStart;
  final DateTime dateFinish;
  final String activityType;
  final List activeUsers;
  final int target;
  final String targetDescription;
  final String reward;

  ChallengeContest({this.challengeID, this.title, this.image, this.description, this.dateStart, this.dateFinish, this.activityType, this.activeUsers, this.target, this.targetDescription, this.reward});

}