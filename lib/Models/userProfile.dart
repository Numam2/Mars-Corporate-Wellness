
class UserProfile {

  final String uid;
  final String name;
  final String about;
  final String sex;
  final String weight;
  final String height;
  final String preference;
  final String goal;
  final String experience;
  final int caloriesBurnt;
  final DateTime birthday;
  final int accumulatedHours;
  final int accumulatedWorkouts;
  final String profilePic;

  final String level;
  final int points;
  final int levelFrom;
  final int levelTo;

  final List groups;

  final String currentTrainingWeek;
  final String currentTrainingDay;
  final String currentTrainingDuration;
  final bool personalizedRoutine;
  final String trainingRoutine;

  final bool hasPersonalCoach;

  final List<ProgressPictures> progressPictures;

  UserProfile({
    this.uid,
    this.name,
    this.about, 
    this.sex, 
    this.weight, 
    this.height, 
    this.preference, 
    this.goal, 
    this.experience, 
    this.caloriesBurnt, 
    this.birthday, 
    this.accumulatedHours, 
    this.accumulatedWorkouts,
    this.profilePic,
    
    this.level,
    this.points,
    this.levelFrom,
    this.levelTo,

    this.groups,

    this.currentTrainingWeek,
    this.currentTrainingDay,
    this.currentTrainingDuration,
    this.personalizedRoutine,
    this.trainingRoutine,

    this.hasPersonalCoach,

    this.progressPictures,
  }); 

}


class UserActivityList {

  List<UserActivity> userActivityList;
  UserActivityList({this.userActivityList});

}


class UserActivity {

  String trainingType;
  String trainingSession;
  String duration;
  DateTime date;

  UserActivity({
    this.trainingType,
    this.trainingSession,
    this.duration,
    this.date,
  });

}


class ProgressPictureList {

  List<ProgressPictures> progressPicturesList;
  ProgressPictureList({this.progressPicturesList});

}


class ProgressPictures {
  String image;
  DateTime date;
  ProgressPictures({this.image, this.date});
}


class GroupNotificationList {
  final List<GroupNotifications> groupNotifications;
  GroupNotificationList({this.groupNotifications});
}


class GroupNotifications {
  String group;
  String type;
  String senderID;
  DateTime date;
  GroupNotifications({this.group, this.type, this.senderID, this.date});
}