import 'package:personal_trainer/Firebase_Services/database.dart';

class LevelTracker {

  String nextLevel;
  int nextLevelFrom;
  int nextLevelTo;

  LevelTracker({this.nextLevel, this.nextLevelFrom, this.nextLevelTo});
  
  void updateLevel(int pointsForLevel) async {

      if (pointsForLevel == 499){

        nextLevel = 'Level 2';
        nextLevelFrom = 500;
        nextLevelTo = 1999;

      } else if (pointsForLevel == 1999){

        nextLevel = 'Level 3';
        nextLevelFrom = 2000;
        nextLevelTo = 4999;
        
      } else if (pointsForLevel == 4999){

        nextLevel = 'Level 4';
        nextLevelFrom = 5000;
        nextLevelTo = 9999;
        
      } else if (pointsForLevel == 9999){

        nextLevel = 'Level 5';
        nextLevelFrom = 10000;
        nextLevelTo = 14999;

      } else if (pointsForLevel == 14999){

        nextLevel = 'Level 6';
        nextLevelFrom = 15000;
        nextLevelTo = 24999;

      } else if (pointsForLevel == 24999){

        nextLevel = 'Level 7';
        nextLevelFrom = 25000;
        nextLevelTo = 39999;

      } else {

        nextLevel = 'Champion';
        nextLevelFrom = 40000;
        nextLevelTo = 100000;

      }

      await DatabaseService().updateUserLevel(nextLevel, nextLevelFrom, nextLevelTo);

    } 

}