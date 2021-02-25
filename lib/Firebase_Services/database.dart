import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_trainer/Models/Recipes.dart';
import 'package:personal_trainer/Models/challenge.dart';
import 'package:personal_trainer/Models/exerciseDetail.dart';
import 'package:personal_trainer/Models/explore.dart';
import 'package:personal_trainer/Models/goals.dart';
import 'package:personal_trainer/Models/organization.dart';
import 'package:personal_trainer/Models/posts.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Models/weeks.dart';
import 'package:personal_trainer/Models/workout.dart';


class DatabaseService {

  final String uid;
  DatabaseService({this.uid});


  //Collection reference routines
  final CollectionReference routine = FirebaseFirestore.instance.collection('Training Routine');
  //Collection reference profile
  final CollectionReference profile = FirebaseFirestore.instance.collection('User Profile');
  //Collection reference profile
  final CollectionReference challenges = FirebaseFirestore.instance.collection('Challenges');

  Future createUserProfile (String name, List searchName, String organization) async {
    return await profile.doc(uid).set({
      'UID': uid,
      'Name': name,
      'About': '',
      'Search Name': searchName,
      'Sex': 'Sex',
      'Birthday': DateTime.parse("1994-01-01 12:00:00"),
      'Weight': '0.0',
      'Height': '0.0',
      'Experience': 0,
      'Preferences': [],
      'Goals': [],
      'Accumulated Workouts': 0,
      'Accumulated Hours': 0,
      'Profile Image': 'https://firebasestorage.googleapis.com/v0/b/ludus-health-coach.appspot.com/o/Profile%20Images%2FNew%20User.jpg?alt=media&token=f08bc2e6-da37-4fcc-95f7-127a5de3ec52',
      'Calories Burnt': 0,
      'Progress Pictures': [],
      'Group Notifications': [],
      'Activity': [],
      'Organization': organization,

      'Level': 'Level 1',
      'Points': 0,
      'Level From': 0,
      'Level To': 499,

      'Groups': [],
      'Current Training Week': '',
      'Current Training Day': '',
      'Current Training Duration': '',
      'Current Training Routine': '',
      'Personalized Routine': false,
      'Personal Coach': false,
      'Active Organization Challenges': {},
      
    });
  }

  Future updateUserData (name, sex, birthday, weight, height, experience, preferences, goals, workoutsDone, hoursDone, caloriesBurnt) async {
    return await profile.doc(uid).set({
     'Name': name,
     'Sex': sex ?? 'Other',
     'Age': birthday ?? '30',
     'Weight': weight,
     'Height': height,
     'Experience': experience,
     'Preferences': preferences,
     'Goals': goals,
     'Accumulated Workouts': workoutsDone,
     'Accumulated Hours': hoursDone,
     'Calories Burnt': caloriesBurnt,
    });
  }

  Future editUserData(name, about, sex, weight) async {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    return await FirebaseFirestore.instance
        .collection('User Profile')
        .doc(uid)
        .update({
      'Name': name,
      'About': about,
      'Sex': sex,
      'Weight': weight,
    });
  }

  Future createUserRoutine (String day) async {
    return await routine.doc(uid).collection('Semana 1').doc('Día 1').set({
      'Day': day,
    });
  }

  Future createUserImage (uid, storageUrl) async {
    return await profile.doc(uid).update({
     'Profile Image': storageUrl,
    });
  }

  Future havePersonalizedCoach (bool hasPersonalCoach) async {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    return await profile.doc(uid).update({
     'Personal Coach': hasPersonalCoach,
    });
  }

  //List of Organizations
  List<Organization> _organizationsListFromSnapshot (QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return Organization(
        organizationName: doc.data()['Name'] ?? '',
        searchName: doc.data()['Search Name'] ?? [],
        logo: doc.data()['Logo'] ?? '',
        domain: doc.data()['Domain'] ?? '',
        );
      }
    ).toList();
  }

  // Organizations Search
  Stream <List<Organization>> searchOrganizations (String organizationSearch) async*{
    yield* FirebaseFirestore.instance.collection('Organizations').where('Search Name', arrayContains: organizationSearch).snapshots().map(_organizationsListFromSnapshot);
  }

  // Record Organization Monthly Statistics
  Future recordOrganizationStats (String organization, String activityType) async {

    final String monthYear = DateTime.now().year.toString() + DateTime.now().month.toString();
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    FirebaseFirestore.instance.collection('Organizations').doc(organization).collection('Stats').doc(monthYear).update({
      activityType: FieldValue.arrayUnion([uid])

      // 'Goals Set':
      // 'Goals Achieved':
      // 'Habits Started':
      // 'Habits Adopted':
      // 'Challenges Accepted':
      // 'Challenges Completed':
      // 'Workouts Completed':
      // 'Recipe Views':
      // 'Recipes Saved':
      // 'Feed Posts':
      // 'Feed Likes':
      // 'Article reads':   

      // 'Yoga Sessions':
      // 'Mindfulness Sessions':
      
    });
  }
  Future recordOrganizationCountStats (String organization, String activityType, int count) async {

    final String monthYear = DateTime.now().year.toString() + DateTime.now().month.toString();

    FirebaseFirestore.instance.collection('Organizations').doc(organization).collection('Stats').doc(monthYear).update({
      activityType: FieldValue.arrayUnion([count])
      // 'Workout Time in Minutes':
      // 'Calories Burnt'
      
      // 'Yoga Time in Minutes':
      // 'Mindfulness Time in Minutes:':
      

    });
  }



///////////////////////// Home Routine Explorer Streams ////////////////////////// 

  // Free Routines list from snapshot
  List<ExploreRoutines> _exploreRoutines (QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return ExploreRoutines(
        name: doc.data()['Name'] ?? '',
        image: doc.data()['Image'] ?? '',
        author: doc.data()['Author'] ?? '',
        duration: doc.data()['Duration'] ?? '',
        description: doc.data()['Description'] ?? '',
        objectives: doc.data()['Objectives'] ?? [],
        equipment: doc.data()['Equipment'] ?? [],
        firstWeek: doc.data()['First Week'] ?? '',
        firstDay: doc.data()['First Day'] ?? '',
        dateUploaded: doc.data()['Date'].toDate() ?? DateTime.now(),
        userGoals: doc.data()['User Goals'] ?? [],
        userSex: doc.data()['Male Only'] ?? false,
        userExperience: doc.data()['User Experience'] ?? 0,
        );
      }
    ).toList();
  }

  // Free Routines Stream
  Stream <List<ExploreRoutines>> freeRoutinesList (List userGoals, int userExperience) {
    return FirebaseFirestore.instance.collection('Free Routines')
      .where('Tag', isEqualTo: 'Routine')
      .where('User Goals', arrayContainsAny: userGoals)
      // .where('User Experience', isLessThanOrEqualTo: userExperience)
      .limit(5).snapshots().map(_exploreRoutines);
  }
  Stream <List<ExploreRoutines>> allRoutinesList () {
    return FirebaseFirestore.instance.collection('Free Routines')
      .where('Tag', isEqualTo: 'Routine')
      .snapshots().map(_exploreRoutines);
  }

  // Free Individual Workouts list from snapshot
  List<ExploreWorkouts> _exploreWorkouts (QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return ExploreWorkouts(
        name: doc.data()['Name'] ?? '',
        image: doc.data()['Image'] ?? '',
        author: doc.data()['Author'] ?? '',
        duration: doc.data()['Duration'] ?? '',
        description: doc.data()['Description'] ?? '',
        objectives: doc.data()['Objectives'] ?? [],
        equipment: doc.data()['Equipment'] ?? [],
        dateUploaded: doc.data()['Date'].toDate() ?? DateTime.now(),
        userGoals: doc.data()['User Goals'] ?? [],
        // userSex: doc.data()['Male Only'] ?? false,
        userExperience: doc.data()['User Experience'] ?? 0,
        );
      }
    ).toList();
  }

  // Free Individual Workouts Stream
  Stream <List<ExploreWorkouts>> freeWorkoutsList (String category, List userGoals) {
    return FirebaseFirestore.instance.collection('Free Routines').doc('Individual Workouts').collection('Workout List')
    .where('Category', isEqualTo: category)
    .where('User Goals', arrayContainsAny: userGoals)
    .orderBy('Date')
    .limit(8).snapshots().map(_exploreWorkouts);
  }
  Stream <List<ExploreWorkouts>> allWorkoutsList (String category) {
    return FirebaseFirestore.instance.collection('Free Routines').doc('Individual Workouts').collection('Workout List')
    .where('Category', isEqualTo: category)
    .orderBy('Date')
    .snapshots().map(_exploreWorkouts);
  }

  //Workout Sets list from snapshot
  List<Workout> _individualWorkoutFromSnapshot (QuerySnapshot snapshot) {                                                              
    return snapshot.docs.map((doc){ 
      return 
      Workout(
        rounds: doc.data()["Rounds"] ?? "",
        stage: doc.data()["Stage"] ?? "",
        sets:  doc.data()["Workout"].map<Exercise>((item){
          return Exercise(
            exerciseName: item['Description'] ?? '',
            reps: item['Reps'] ?? '',
            weight: item['Weight'] ?? '',
          );
        }).toList(),
      );
    }).toList();
  }

  //Get Workout Streams
  Stream<List<Workout>> individualWorkout (workout) async* {
    yield* FirebaseFirestore.instance.collection('Individual Workouts').doc(workout).collection('Workout').snapshots().map(_individualWorkoutFromSnapshot);
  }





///////////////////////// Workout Streams ////////////////////////// 

  //Weeks list from snapshot
  List<WeekDays> _daysListFromSnapshot (QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){ 
      return 
      WeekDays(
        day: doc.data()["Day"] ?? "",
        week: doc.data()["Week"] ?? "",
        currentDayIndex: doc.data()["Current Day Index"] ?? 1,
        maxDayIndex: doc.data()["Max Day Index"] ?? 5,
        nextWeek: doc.data()["Next Week"] ?? '',
        focus: doc.data()["Focus"] ?? "",
        time: doc.data()["Time"] ?? "",
        bodyPart: doc.data()["Body part"] ?? "",
      );
    }).toList();
  }

  //Get Workout Weeks Streams
  Stream<List<WeekDays>> weekDays (collection, id, weekNumber) async* {
    yield* FirebaseFirestore.instance.collection(collection).doc(id).collection(weekNumber).snapshots().map(_daysListFromSnapshot);
  }

  // Week Day Workout Details from snapshot
  WeekDays _trainingDayDetailsfromSnapshot (DocumentSnapshot snapshot){
      return WeekDays(
        day: snapshot.data()["Day"] ?? "",
        week: snapshot.data()["Week"] ?? "",
        currentDayIndex: snapshot.data()["Current Day Index"] ?? 1,
        maxDayIndex: snapshot.data()["Max Day Index"] ?? 5,
        nextWeek: snapshot.data()["Next Week"] ?? 'Done',
        nextDay: snapshot.data()["Next Day"] ?? 'Done',
        nextTime: snapshot.data()["Next Time"] ?? '45 min',
        focus: snapshot.data()["Focus"] ?? "",
        time: snapshot.data()["Time"] ?? "",
        bodyPart: snapshot.data()["Body part"] ?? "",
        exercises: List.from(snapshot.data()["Exercises"]) ?? [],
      );
  }

  // Week Day Workout Details Stream
  Stream <WeekDays> trainingDayDetails (collection, id, weekNumber, dayNumber) async*{
    yield* FirebaseFirestore.instance.collection(collection).doc(id).collection(weekNumber).doc(dayNumber).snapshots().map(_trainingDayDetailsfromSnapshot);
  }

 //Workout Sets list from snapshot
  List<Workout> _workoutFromSnapshot (QuerySnapshot snapshot) {
    try{    
      return snapshot.docs.map((doc){ 
        return 
        Workout(
          rounds: doc.data()["Rounds"] ?? "",
          stage: doc.data()["Stage"] ?? 0,
          sets:  doc.data()["Workout"].map<Exercise>((item){
            return Exercise(
              exerciseName: item['Description'] ?? '',
              reps: item['Reps'] ?? '',
              weight: item['Weight'] ?? '',
              duration: item['Duration'] ?? 0,
              side: item['Side'] ?? '',
            );
          }).toList(),
        );
      }).toList();
    }catch(e){
      print(e.toString()); 
      return null;
    }
  }

  //Get Workout Streams
  Stream<List<Workout>> dayWorkout (collection, id, weekNumber, dayNumber) async* {
    yield* FirebaseFirestore.instance.collection(collection).doc(id).collection(weekNumber).doc(dayNumber).collection('Workout').snapshots().map(_workoutFromSnapshot);
  }
  


  // Exercise Detail from snapshot
  ExerciseDetail _exerciseDetailfromSnapshot (DocumentSnapshot snapshot){
      return ExerciseDetail(
        // description: snapshot.data()['Description'] ?? '',
        // tips: snapshot.data()['Tips'] ?? '', 
        video: snapshot.data()['Video'] ?? '',
        image: snapshot.data()['Image'] ?? '',      
        // tags: List.from(snapshot.data()['Tags']) ?? [], 
        // equipment: List.from(snapshot.data()['Equipment']) ?? [], 
      );
  }

  // Exercise Detail Stream
  Stream <ExerciseDetail> exerciseDetail (exercise) async*{
    yield* FirebaseFirestore.instance.collection('Exercise List').doc(exercise).snapshots().map(_exerciseDetailfromSnapshot);
  }



  // Record next workout from my plan
  Future updateUserWorkoutProgress (bool personalizedRoutine, String routineName, String nextTraingDay, String nextTrainingWeek, String nextTrainingDuration) async {

    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    return await profile.doc(uid).update({
      'Personalized Routine': personalizedRoutine ?? true,
      'Current Training Routine': routineName,
      'Current Training Day': nextTraingDay,
      'Current Training Week': nextTrainingWeek,
      'Current Training Duration': nextTrainingDuration,
    });
  }

  //Save to user Log Activity
  Future saveTrainingSession (String trainingType, String duration, String trainingSession,) async {

    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    return await profile.doc(uid).update({
      'Activity': FieldValue.arrayUnion([{
          'Training Type': trainingType,
          'Session': trainingSession ?? '',
          'Duration': duration,
          'Date': DateTime.now(),
        }]
      ),       
    });
  }




  // Activity List from snapshot
  UserActivityList _activityLogfromSnapshot (DocumentSnapshot snapshot){
    try{
      return UserActivityList(        
        userActivityList: snapshot.data()["Activity"].map<UserActivity>((item){
          return UserActivity(
            trainingType: item['Training Type'] ?? '',
            trainingSession: item['Session'] ?? '',
            duration: item['Duration'] ?? '',
            date: item['Date'].toDate() ?? '',
          );
        }).toList(),
      );
    } catch(e){
      print(e.toString()); 
      return null;
    }
  }
  
  // Activity List Stream
  Stream <UserActivityList> get activityLog async*{
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    yield* profile.doc(uid).snapshots().map(_activityLogfromSnapshot);
  }


  ProgressPictureList _progressPics (DocumentSnapshot snapshot){
    try{
      return ProgressPictureList(        
        progressPicturesList: snapshot.data()["Progress Pictures"].map<ProgressPictures>((item){
          return ProgressPictures(
            image: item['Image'] ?? '',
            date: item['Date'].toDate() ?? '',
          );
        }).toList(),
      );
    } catch(e){
      print(e.toString()); 
      return null;
    }
  }


  // Activity List Stream
  Stream <ProgressPictureList> get progressPictures async*{
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    yield* profile.doc(uid).snapshots().map(_progressPics);
  }

  //Save Progress Picture
  Future saveProgressPicture (String image) async {

    final User user =  FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    return await profile.doc(uid).update({
      'Progress Pictures': FieldValue.arrayUnion([{
          'Image': image ?? '',
          'Date': DateTime.now() ?? '',
        }]
      ),       
    });
  }

  //Delete Progress Picture
  Future deleteProgressPicture (image, date) async {

    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    return await profile.doc(uid).update({
      'Progress Pictures': FieldValue.arrayRemove([{
          'Image': image ?? '',
          'Date': date ?? '',
        }]
      ),       
    });
  }



///////////////////////// Profile Streams ////////////////////////// 

  // Profile from snapshot
  UserProfile _userDatafromSnapshot (DocumentSnapshot snapshot){
    try{
      return UserProfile(
        uid: snapshot.data()['UID'] ?? '',
        name: snapshot.data()['Name'] ?? '',
        about: snapshot.data()['About'] ?? '',
        sex: snapshot.data()['Sex'] ?? '', 
        weight: snapshot.data()['Weight'] ?? '', 
        height: snapshot.data()['Height'] ?? '', 
        preferences: snapshot.data()['Preferences'] ?? [], 
        goals: snapshot.data()['Goals'] ?? [], 
        experience: snapshot.data()['Experience'] ?? '', 
        caloriesBurnt: snapshot.data()['Calories Burnt'] ?? 0, 
        birthday: snapshot.data()['Birthday'].toDate() ?? DateTime.parse("1994-01-01 12:00:00"),
        accumulatedHours: snapshot.data()['Accumulated Hours'] ?? 0, 
        accumulatedWorkouts: snapshot.data()['Accumulated Workouts'] ?? 0,
        profilePic: snapshot.data()['Profile Image'] ?? 'https://firebasestorage.googleapis.com/v0/b/ludus-health-coach.appspot.com/o/Profile%20Images%2FNo%20User.png?alt=media&token=0312211c-026c-432b-98b5-e4e03bcbe386',

        level: snapshot.data()['Level'] ?? 'Level 1',
        points: snapshot.data()['Points'] ?? 0,
        levelFrom: snapshot.data()['Level From'] ?? 0,
        levelTo: snapshot.data()['Level To'] ?? 499,

        groups: snapshot.data()['Groups'] ?? [],
        organization: snapshot.data()['Organization'] ?? '',

        currentTrainingWeek: snapshot.data()['Current Training Week'] ?? '',
        currentTrainingDay: snapshot.data()['Current Training Day'] ?? '',
        currentTrainingDuration: snapshot.data()['Current Training Duration'] ?? '',
        trainingRoutine: snapshot.data()['Current Training Routine'] ?? '',
        personalizedRoutine: snapshot.data()['Personalized Routine'] ?? false,

        hasPersonalCoach: snapshot.data()['Personal Coach'] ?? false,

        activeOrganizationChallenges: snapshot.data()['Active Organization Challenges'] ?? {}
        
      );
    } catch(e){
      print(e);
      return null;
    }
  }

  // Profile Stream
  Stream <UserProfile> get userData async*{
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    yield* profile.doc(uid).snapshots().map(_userDatafromSnapshot);
  }





  //Update User Stats
  Future updateUserStats (int workout, int caloriesBurnt, int hours, int points) async {

    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    return await profile.doc(uid).update({
     'Accumulated Workouts': workout,
      'Calories Burnt': caloriesBurnt,
      'Accumulated Hours': hours,
      'Points': points,
    });
  }

  Future updateUserPoints (int points) async {

    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    return await profile.doc(uid).update({
      'Points': points,
    });
  }



  //Update User Level
  Future updateUserLevel (level, levelFrom, levelTo) async {

    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    return await profile.doc(uid).update({
     'Level': level ?? 'Champion',
     'Level From': levelFrom ?? 40000,
     'Level To': levelTo ?? 100000,
    });
  }







///////////////////////// Challenges Streams from Firestore ////////////////////////// 

  // Personal Challenge List from snapshot
  List<Challenge> _challengeListFromSnapshot (QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return Challenge(
        description: doc.data()['Description'] ?? '',
        lastChecked: doc.data()['Last Checked'] ?? '0',        
        currentDay: doc.data()['Current Day'] ?? 0,
        totalDays: doc.data()['Total Days'] ?? 7,
        created: doc.data()['Created'].toDate() ?? DateTime.now(),
        );
      }
    ).toList();
  }

  // Personal Challenges Stream
  Stream <List<Challenge>> get challengeList async*{

    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    yield* challenges.doc(uid).collection('My Challenges').snapshots().map(_challengeListFromSnapshot);
  }



  // Popular Challenges List from snapshot
  List<PopularChallenges> _popularChallenges (QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return PopularChallenges(
        description: doc.data()['Description'] ?? '',
        image: doc.data()['Image'] ?? '',
        totalDays: doc.data()['Total Days'] ?? 7,
        );
      }
    ).toList();
  }

  // Popular Challenges Stream
  Stream <List<PopularChallenges>> get popularChallengeList {
    return challenges.doc('Challenge Recommendations').collection('Challenges').snapshots().map(_popularChallenges);
  }



  // Organizations Challenge List from snapshot
  List<ChallengeContest> _challengeContestsFromSnapshot (QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return ChallengeContest(
        challengeID: doc.data()['Challenge ID'] ?? '',
        title: doc.data()['Title'] ?? '',
        image: doc.data()['Image'] ?? '',
        activityType: doc.data()['Type'] ?? '',
        target: doc.data()['Target'] ?? 0,
        activeUsers: doc.data()['Active Users'] ?? [],
        dateStart: doc.data()['Date Start'].toDate() ?? DateTime.now(),
        dateFinish:doc.data()['Date Finish'].toDate() ?? DateTime.now(),
        description: doc.data()['Description'] ?? '',
        targetDescription: doc.data()['Target Description'] ?? '',
        reward: doc.data()['Reward'] ?? '',
        );
      }
    ).toList();
  }

  // Organizations Challenges Stream
  Stream <List<ChallengeContest>> challengeContests (String userOrganization) async*{
    yield* FirebaseFirestore.instance.collection('Organizations').doc(userOrganization).collection('Challenges').snapshots().map(_challengeContestsFromSnapshot);
  }

  // Add user to org challenge
  Future joinOrgChallenge(groupName, challengeID, challengeTitle, type, int target, DateTime dateFinish) async {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    return await profile.doc(uid).update({
      'Active Organization Challenges':
        {
          'Challenge ID': challengeID,
          'Challenge Title': challengeTitle,
          'Status': 'En progreso',
          'Type': type,
          'Target Steps': target,
          'Completed Steps': 0,
          'Date Finish': dateFinish,
        }
    });
  }

  // Delete Org Challenge
  Future deleteOrgChallenge() async {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    return await profile.doc(uid).update({
      'Active Organization Challenges': {}      
    });      
  }

  ///// RECORD ORGANIZATION CHALLEGE COUNT / POINTS
  Future updateOrgChallenge(status, int currentSteps) async {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    return await profile.doc(uid).update({
      'Active Organization Challenges.Status': status,
      'Active Organization Challenges.Completed Steps': currentSteps,
    });      
  }

  ///// Update challenge completed user count
  Future updateChallengeCompletedCount (String userOrganization, String challengeID) async {

    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    return await FirebaseFirestore.instance.collection('Organizations').doc(userOrganization).collection('Challenges').doc(challengeID).update({
      'Users Completed': FieldValue.arrayUnion([uid] ?? ''),
    });
  }


///////////////////////// Goals Streams from Firestore ////////////////////////// 

    // Personal Goal List from snapshot
  List<Goals> _goalListFromSnapshot (QuerySnapshot snapshot){
    try{
      return snapshot.docs.map((doc){
        return Goals(
          description: doc.data()['Description'] ?? '',
          initialValue: doc.data()['Initial Value'].toDouble() ?? 0, 
          targetValue: doc.data()['Target Value'].toDouble() ?? 0,
          currentValue: doc.data()['Current Value'].toDouble() ?? 0,
          stage: doc.data()['Stage'] ?? 'In Progress',
          unit: doc.data()['Unit'] ?? '',
          dateFrom: doc.data()['DateFrom'].toDate(),
          dateTo: doc.data()['DateTo'].toDate(),
          goalType: doc.data()['Goal Type'] ?? '',
          milestones: doc.data()['Milestones'].map<Milestones>((item){
            return Milestones(
              description: item['Milestone'] ?? '',
              complete: item['Complete'] ?? false,            
            );
            }).toList(),
          );
        }
      ).toList();
    } catch(e){
      print(e);
      return null;
    }
  }

  // Personal Goal Stream
  Stream <List<Goals>> get goalList async*{

    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    yield* FirebaseFirestore.instance.collection('Goals').doc(uid).collection('My Goals').snapshots().map(_goalListFromSnapshot);
  }

  //Update Goal Progress
  Future updateGoalProgress (goal, currentValue) async {

    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    return await FirebaseFirestore.instance.collection('Goals').doc(uid).collection('My Goals').doc(goal).update({
     'Current Value': currentValue,
    });
  }

  //Create Goal
  Future createGoal (goal, initialValue, currentValue, targetValue, unit, dateTo, goalType, milestones) async {

    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    return await FirebaseFirestore.instance.collection('Goals').doc(uid).collection('My Goals').doc(goal).set({
     'Description': goal ?? '',
     'Initial Value': initialValue ?? 0,
     'Target Value': targetValue ?? 0,
     'Current Value': currentValue ?? 0,
     'Stage': 'In Progress',
     'Unit': unit ?? '',
     'DateFrom': DateTime.now(),
     'DateTo': dateTo,
     'Goal Type': goalType,
     'Milestones': milestones ?? [],
    });
  }

  //Delete Goal
  Future deleteGoal (goal) async {

    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    return await FirebaseFirestore.instance.collection('Goals').doc(uid).collection('My Goals').doc(goal).delete();
  } 

  //Update Milestone Completion
  Future updateMilestone (String goal, List newList) async {

    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    return await FirebaseFirestore.instance.collection('Goals').doc(uid).collection('My Goals').doc(goal).update({
      'Milestones': newList     
    });
  }



///////////////////////// Social Streams from Firestore ////////////////////////// 


  // Organization from snapshot
  Organization _organizationfromSnapshot (DocumentSnapshot snapshot){
      return Organization(
        organizationName: snapshot.data()['Name'] ?? '',
        searchName: snapshot.data()['Search Name'] ?? [],
        logo: snapshot.data()['Logo'] ?? '',
        domain: snapshot.data()['Domain'] ?? '',
      );
  }

  // Organization Stream
  Stream <Organization> organizationData (String organizationName) async*{
    yield* FirebaseFirestore.instance.collection('Organizations').doc(organizationName).snapshots().map(_organizationfromSnapshot);
  }

  // Group Feed
  List<Post> _feedFromSnapshot (QuerySnapshot snapshot){
    try {
      return snapshot.docs.map((doc){
        return Post(
          postID: doc.data()['Post ID'],
          ownerUID: doc.data()['Owner ID'],
          date: doc.data()['Time'].toDate(),
          likes: doc.data()['Likes'] ?? [],
          textContent: doc.data()['Text Content'] ?? '',
          media: doc.data()['Media'] ?? '',
          location: doc.data()['Location'] ?? '',
          comments: doc.data()["Comments"].map<PostComments>((item){
            return PostComments(
              userID: item['Sender'] ?? '',
              comment: item['Comment'] ?? '',            
            );
            }).toList(),

          type: doc.data()['Type'] ?? null,
          headline: doc.data()['Headline'] ?? '',
          subtitle: doc.data()['Subtitle'] ?? '',
        );
      }).toList();
    } catch(e){
      return null;
    }
  }

  // Feed Stream
  Stream <List<Post>> groupFeed (organizationName) async*{
    yield* FirebaseFirestore.instance.collection('Organizations').doc(organizationName).collection('Posts').orderBy('Time', descending: true).limit(15).snapshots().map(_feedFromSnapshot);
  }

  // Individual Post from snapshot (Comments)
  Post _postfromSnapshot (DocumentSnapshot snapshot){
    return Post(
        postID: snapshot.data()['Post ID'] ?? '',
        ownerUID: snapshot.data()['Owner ID'] ?? '',
        date: snapshot.data()['Time'].toDate() ?? '',
        likes: snapshot.data()['Likes'] ?? [],
        textContent: snapshot.data()['Text Content'] ?? '',
        media: snapshot.data()['Media'] ?? '',
        location: snapshot.data()['Location'] ?? '',
        comments: snapshot.data()["Comments"].map<PostComments>((item){
          return PostComments(
            userID: item['Sender'] ?? '',
            comment: item['Comment'] ?? '',
            time: item['Time'].toDate() ?? '',
          );
        }).toList(),
        
        type: snapshot.data()['Type'] ?? null,
        headline: snapshot.data()['Headline'] ?? '',
        subtitle: snapshot.data()['Subtitle'] ?? '',
    );
  }

  // Individual Post Stream (Comments)
  Stream <Post> post (groupName, postID) async*{
    yield* FirebaseFirestore.instance.collection('Organizations').doc(groupName).collection('Posts').doc(postID).snapshots().map(_postfromSnapshot);
  }

  // Individual Post from snapshot (Comments)
  List<Article> _articlesfromSnapshot (QuerySnapshot snapshot){
    try {
      return snapshot.docs.map((doc){
        return Article(
        title: doc.data()['Title'] ?? '',
        author: doc.data()['Author'] ?? '',
        date: doc.data()['Date'].toDate() ?? DateTime.now(),
        userReads: doc.data()['User Reads'] ?? [],
        image: doc.data()['Image'] ?? '',
        articleID: doc.data()['ID'] ?? '',
        content: doc.data()["Content"].map<ArticleContent>((item){
          return ArticleContent(
            text: item['Text'] ?? '',
            type: item['Type'] ?? '',
          );
        }).toList(),        
    );
      }).toList();
    } catch(e){
      return null;
    }
  }

  // Individual Post Stream (Comments)
  Stream <List<Article>> articles (groupName) async*{
    yield* FirebaseFirestore.instance.collection('Organizations')
    .doc(groupName).collection('Articles')
    .orderBy('Date')
    .snapshots().map(_articlesfromSnapshot);
  }


  //Create Post
  Future createPost(groupName, textContent, media) async {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    String docID = DateTime.now().toString(); 

    return await FirebaseFirestore.instance.collection('Organizations').doc(groupName).collection('Posts').doc(docID).set({
      'Post ID': docID,
      'Owner ID': uid,
      'Time': DateTime.now(),
      'Likes': [],
      'Text Content': textContent,
      'Media': media ?? '',
      'Comments': [],
    });
  }
  Future createSharedPost(groupName, textContent, media, type, headline, subtitle) async {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    String docID = DateTime.now().toString(); 

    return await FirebaseFirestore.instance.collection('Organizations').doc(groupName).collection('Posts').doc(docID).set({
      'Post ID': docID,
      'Owner ID': uid,
      'Time': DateTime.now(),
      'Likes': [],
      'Text Content': textContent,
      'Media': media ?? '',
      'Comments': [],
      'Type': type,
      'Headline': headline,
      'Subtitle': subtitle,
    });
  }


  // Post Header Owner
  UserProfile _postOwnerfromSnapshot (DocumentSnapshot snapshot){
      return UserProfile(
        name: snapshot.data()['Name'] ?? '',
        about: snapshot.data()['About'] ?? '',
        uid: snapshot.data()['UID'] ?? '',
        profilePic: snapshot.data()['Profile Image'] ?? 'https://firebasestorage.googleapis.com/v0/b/ludus-health-coach.appspot.com/o/Profile%20Images%2FNo%20User.png?alt=media&token=0312211c-026c-432b-98b5-e4e03bcbe386',
      );
  }

  // Post Owner Stream
  Stream <UserProfile> postOwner(ownerID) async*{
    yield* profile.doc(ownerID).snapshots().map(_postOwnerfromSnapshot);
  }


  //Interact with Post : Like/Unlike
  //Like
  Future likePost(groupName, postID) async {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    return await FirebaseFirestore.instance.collection('Organizations').doc(groupName).collection('Posts').doc(postID).update({
      'Likes': FieldValue.arrayUnion([uid] ?? ''),
    });
  }

  //Unlike
  Future unlikePost(groupName, postID) async {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    return await FirebaseFirestore.instance.collection('Organizations').doc(groupName).collection('Posts').doc(postID).update({
      'Likes': FieldValue.arrayRemove([uid] ?? ''),
    });
  }


  //Comment in Post
  Future commentPost(groupName, postID, commentText) async {

    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    return await FirebaseFirestore.instance.collection('Organizations').doc(groupName).collection('Posts').doc(postID).update({
     'Comments': FieldValue.arrayUnion([{
          'Time': DateTime.now(),
          'Sender': uid,
          'Comment': commentText,
        }]
      ),     
    });
  }
  

  //Notify me likes and comments
  Future notifyLikesComments (String postOwnerUID, String likeorComment, String group) async {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    return await profile.doc(postOwnerUID).update({
      'Group Notifications': FieldValue.arrayUnion([{
          'Notification Type': likeorComment,  
          'Group': group ?? '',
          'Requester UID': uid ?? '',
          'Date': DateTime.now(),
        }]
      ),       
    });
  }


  // Group Notifications from snapshot
  GroupNotificationList _groupNotificationsfromSnapshot (DocumentSnapshot snapshot){
    try{
      return GroupNotificationList(        
        groupNotifications: snapshot.data()["Group Notifications"].map<GroupNotifications>((item){
          return GroupNotifications(
            group: item['Group'] ?? '',
            type: item['Notification Type'] ?? '',
            senderID: item['Requester UID'] ?? '',
            date: item['Date'].toDate() ?? '',
          );
        }).toList(),
      );
    } catch(e){
      print(e.toString()); 
      return null;
    }
  }
  
  // Group Notifications Stream
  Stream <GroupNotificationList> get groupNotifications async*{
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    yield* profile.doc(uid).snapshots().map(_groupNotificationsfromSnapshot);
  }
  
  //Delete Group Notification
  Future deleteGroupNotification (date, String group, String type, String senderUID) async {

    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    return await profile.doc(uid).update({
      'Group Notifications': FieldValue.arrayRemove([{
          'Date': date ?? '',
          'Group': group ?? '',
          'Notification Type': type ?? '',
          'Requester UID': senderUID ?? '',
        }]
      ),       
    });
  }
  Future clearAllNotifications () async {

    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    return await profile.doc(uid).update({
      'Group Notifications': []           
    });
  }

  //Comment in Post
  Future readArticle (groupName, articleID) async {

    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    return await FirebaseFirestore.instance.collection('Organizations').doc(groupName).collection('Articles').doc(articleID).update({
     'User Reads': FieldValue.arrayUnion([uid]),     
    });
  }




///////////////////////// Nutrition Recipes Streams from Firestore ////////////////////////// 

  // Recipes List
  List<Recipes> _recipesFromSnapshot (QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return Recipes(
        name: doc.data()['Name'] ?? '',
        image: doc.data()['Image'] ?? '',
        author: doc.data()['Author'] ?? '',
        intro: doc.data()['Intro'] ?? '',
        time: doc.data()['Time'] ?? '',
        category: doc.data()['Category'] ?? '',
        directions: doc.data()['Directions'] ?? [],
        tags: doc.data()['Tags'] ?? [],
        ingredients: doc.data()['Ingredients'] ?? [],
        likes: doc.data()['Likes'] ?? [],
        recipeID: doc.id,
        dateUploaded: doc.data()['Date'].toDate() ?? DateTime.now(),
        userGoals: doc.data()['User Goals'] ?? [],
      );
    }).toList();
  }

  // Recipes Stream
  Stream <List<Recipes>> reipes (String tag) async*{
    yield* FirebaseFirestore.instance.collection('Recipes').where('Tags', arrayContains: tag).limit(10).snapshots().map(_recipesFromSnapshot);
  }

  // Saved Recipes Stream
  Stream <List<Recipes>> savedRecipes () async*{
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    yield* FirebaseFirestore.instance.collection('Recipes')
    .where('Likes', arrayContains: uid)
    .snapshots().map(_recipesFromSnapshot);
  }

  // Saved Recipes Stream
  Stream <List<Recipes>> recommendedRecipes (List userGoals) async*{
    yield* FirebaseFirestore.instance.collection('Recipes')
    .where('User Goals', arrayContainsAny: userGoals)
    .orderBy('Date')
    .snapshots().map(_recipesFromSnapshot);
  }

  //Like
  Future likeRecipe(recipeID) async {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    return await FirebaseFirestore.instance.collection('Recipes').doc(recipeID).update({
      'Likes': FieldValue.arrayUnion([uid] ?? ''),
    });
  }

  //Unlike
  Future unlikeRecipe(recipeID) async {
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    return await FirebaseFirestore.instance.collection('Recipes').doc(recipeID).update({
      'Likes': FieldValue.arrayRemove([uid] ?? ''),
    });
  }




}
