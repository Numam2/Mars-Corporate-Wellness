import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_trainer/Models/challenge.dart';
import 'package:personal_trainer/Models/explore.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Models/weeks.dart';


class DatabaseService {

  final String uid;
  DatabaseService({this.uid});


  //Collection reference routines
  final CollectionReference routine = Firestore.instance.collection('Training Routine');
  //Collection reference profile
  final CollectionReference profile = Firestore.instance.collection('User Profile');
  //Collection reference profile
  final CollectionReference challenges = Firestore.instance.collection('Challenges');

  Future updateUserData (name, sex, birthday, weight, height, experience, preference, goal, workoutsDone, hoursDone, caloriesBurnt) async {
    return await profile.document(uid).setData({
     'Name': name,
     'Sex': sex,
     'Age': birthday,
     'Weight': weight,
     'Height': height,
     'Experience': experience,
     'Preference': preference,
     'Goal': goal,
     'Accumulated Workouts': workoutsDone,
     'Accumulated Hours': hoursDone,
     'Calories Burnt': caloriesBurnt,
    });
  }

  Future createUserRoutine (List weeks) async {
    return await routine.document(uid).setData({
      'Weeks': weeks,
    });
  }




///////////////////////// Home Routine Explorer Streams ////////////////////////// 

  // Free Routines list from snapshot
  List<ExploreRoutines> _exploreRoutines (QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return ExploreRoutines(
        name: doc.data['Name'] ?? '',
        image: doc.data['Image'] ?? '',
        duration: doc.data['Duration'] ?? '',
        );
      }
    ).toList();
  }

  // Free Routines Stream
  Stream <List<ExploreRoutines>> get freeRoutinesList {
    return Firestore.instance.collection('Free Routines').snapshots().map(_exploreRoutines);
  }

  // Free Routines list from snapshot
  List<ExploreWorkouts> _exploreWorkouts (QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return ExploreWorkouts(
        name: doc.data['Name'] ?? '',
        image: doc.data['Image'] ?? '',
        duration: doc.data['Duration'] ?? '',
        );
      }
    ).toList();
  }

  // Free Routines Stream
  Stream <List<ExploreWorkouts>> get freeWorkoutsList {
    return Firestore.instance.collection('Individual Workouts').snapshots().map(_exploreWorkouts);
  }




///////////////////////// Workout Week Days Streams ////////////////////////// 

  //Weeks list from snapshot
  List<WeekDays> _daysListFromSnapshot (QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){ 
      return 
      WeekDays(
        day: doc.data["Day"] ?? "",
        focus: doc.data["Focus"] ?? "",
        time: doc.data["Time"] ?? "",
        bodyPart: doc.data["Body Part"] ?? "",
      );
    }).toList();
  }

  //Get Workout Streams
  Stream<List<WeekDays>> get weekDays {
    return routine.snapshots()
    .map(_daysListFromSnapshot);
  }










///////////////////////// Profile Streams ////////////////////////// 

  // Profile from snapshot
  UserProfile _userDatafromSnapshot (DocumentSnapshot snapshot){
      return UserProfile(
        name: snapshot.data['Name'] ?? '',
        sex: snapshot.data['Sex'] ?? '', 
        weight: snapshot.data['Weight'] ?? '', 
        height: snapshot.data['Height'] ?? '', 
        preference: snapshot.data['Preference'] ?? '', 
        goal: snapshot.data['Goal'] ?? '', 
        experience: snapshot.data['Experience'] ?? '', 
        caloriesBurnt: snapshot.data['Calories Burnt'] ?? 0, 
        age: snapshot.data['Age'] ?? '', 
        accumulatedHours: snapshot.data['Accumulated Hours'] ?? 0, 
        accumulatedWorkouts: snapshot.data['Accumulated Workouts'] ?? 0
      );
  }

  // Profile Stream
  Stream <UserProfile> get userData async*{
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    yield* profile.document(uid).snapshots().map(_userDatafromSnapshot);
  }





///////////////////////// Challenges Streams from Firestore ////////////////////////// 

  // Personal Challenge List from snapshot
  List<Challenge> _challengeListFromSnapshot (QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Challenge(
        description: doc.data['Description'] ?? '',
        lastChecked: doc.data['Last Checked'] ?? '0',        
        currentDay: doc.data['Current Day'] ?? 0,
        totalDays: doc.data['Total Days'] ?? 7,
        );
      }
    ).toList();
  }

  // Personal Challenges Stream
  Stream <List<Challenge>> get challengeList async*{

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    yield* challenges.document(uid).collection('My Challenges').snapshots().map(_challengeListFromSnapshot);
  }

  // Popular Challenges List from snapshot
  List<PopularChallenges> _popularChallenges (QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return PopularChallenges(
        description: doc.data['Description'] ?? '',
        image: doc.data['Image'] ?? '',
        totalDays: doc.data['Total Days'] ?? 7,
        );
      }
    ).toList();
  }

  // Popular Challenges Stream
  Stream <List<PopularChallenges>> get popularChallengeList {
    return challenges.document('Challenge Recommendations').collection('Challenges').snapshots().map(_popularChallenges);
  }



}
