import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_trainer/Models/Recipes.dart';
import 'package:personal_trainer/Models/challenge.dart';
import 'package:personal_trainer/Models/exerciseDetail.dart';
import 'package:personal_trainer/Models/explore.dart';
import 'package:personal_trainer/Models/goals.dart';
import 'package:personal_trainer/Models/groups.dart';
import 'package:personal_trainer/Models/messages.dart';
import 'package:personal_trainer/Models/posts.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Models/weeks.dart';
import 'package:personal_trainer/Models/workout.dart';


class DatabaseService {

  final String uid;
  DatabaseService({this.uid});


  //Collection reference routines
  final CollectionReference routine = Firestore.instance.collection('Training Routine');
  //Collection reference profile
  final CollectionReference profile = Firestore.instance.collection('User Profile');
  //Collection reference profile
  final CollectionReference challenges = Firestore.instance.collection('Challenges');

  Future createUserProfile (String name, List searchName) async {
    return await profile.document(uid).setData({
      'UID': uid,
      'Name': name,
      'About': '',
      'Search Name': searchName,
      'Sex': 'Sex',
      'Birthday': DateTime.parse("1994-01-01 12:00:00"),
      'Weight': '0.0',
      'Height': '0.0',
      'Experience': 'None',
      'Preference': 'None',
      'Goal': 'None',
      'Accumulated Workouts': 0,
      'Accumulated Hours': 0,
      'Calories Burnt': 0,
      'Progress Pictures': [],
      'Group Notifications': [],
      'Activity': [],
    });
  }

  Future updateUserData (name, sex, birthday, weight, height, experience, preference, goal, workoutsDone, hoursDone, caloriesBurnt) async {
    return await profile.document(uid).setData({
     'Name': name,
     'Sex': sex ?? 'Other',
     'Age': birthday ?? '30',
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

  Future editUserData(name, about, sex, weight, preference, goal) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    return await Firestore.instance
        .collection('User Profile')
        .document(uid)
        .updateData({
      'Name': name,
      'About': about,
      'Sex': sex,
      'Weight': weight,
      'Preference': preference,
      'Goal': goal,
    });
  }

  Future createUserRoutine (String day) async {
    return await routine.document(uid).collection('Week 1').document('Day 1').setData({
      'Day': day,
    });
  }

  Future createUserImage (uid, storageUrl) async {
    return await profile.document(uid).updateData({
     'Profile Image': storageUrl,
    });
  }

  Future havePersonalizedCoach (bool hasPersonalCoach) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return await profile.document(uid).updateData({
     'Personal Coach': hasPersonalCoach,
    });
  }



///////////////////////// Home Routine Explorer Streams ////////////////////////// 

  // Free Routines list from snapshot
  List<ExploreRoutines> _exploreRoutines (QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return ExploreRoutines(
        name: doc.data['Name'] ?? '',
        image: doc.data['Image'] ?? '',
        author: doc.data['Author'] ?? '',
        duration: doc.data['Duration'] ?? '',
        description: doc.data['Description'] ?? '',
        objectives: doc.data['Objectives'] ?? [],
        equipment: doc.data['Equipment'] ?? [], 
        );
      }
    ).toList();
  }

  // Free Routines Stream
  Stream <List<ExploreRoutines>> get freeRoutinesList {
    return Firestore.instance.collection('Free Routines').where('Tag', isEqualTo: 'Routine').snapshots().map(_exploreRoutines);
  }




  // Free Individual Workouts list from snapshot
  List<ExploreWorkouts> _exploreWorkouts (QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return ExploreWorkouts(
        name: doc.data['Name'] ?? '',
        image: doc.data['Image'] ?? '',
        author: doc.data['Author'] ?? '',
        duration: doc.data['Duration'] ?? '',
        description: doc.data['Description'] ?? '',
        objectives: doc.data['Objectives'] ?? [],
        equipment: doc.data['Equipment'] ?? [],
        );
      }
    ).toList();
  }

  // Free Individual Workouts Stream
  Stream <List<ExploreWorkouts>> freeWorkoutsList (category) {
    return Firestore.instance.collection('Free Routines').document('Individual Workouts').collection('Workout List').where('Category', isEqualTo: category).snapshots().map(_exploreWorkouts);
  }



  //Workout Sets list from snapshot
  List<Workout> _individualWorkoutFromSnapshot (QuerySnapshot snapshot) {                                                              
    return snapshot.documents.map((doc){ 
      return 
      Workout(
        rounds: doc.data["Rounds"] ?? "",
        stage: doc.data["Stage"] ?? "",
        sets:  doc.data["Workout"].map<Exercise>((item){
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
    yield* Firestore.instance.collection('Individual Workouts').document(workout).collection('Workout').snapshots().map(_individualWorkoutFromSnapshot);
  }





///////////////////////// Workout Streams ////////////////////////// 

  //Weeks list from snapshot
  List<WeekDays> _daysListFromSnapshot (QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){ 
      return 
      WeekDays(
        day: doc.data["Day"] ?? "",
        week: doc.data["Week"] ?? "",
        currentDayIndex: doc.data["Current Day Index"] ?? 1,
        maxDayIndex: doc.data["Max Day Index"] ?? 5,
        nextWeek: doc.data["Next Week"] ?? '',
        focus: doc.data["Focus"] ?? "",
        time: doc.data["Time"] ?? "",
        bodyPart: doc.data["Body part"] ?? "",
      );
    }).toList();
  }

  //Get Workout Weeks Streams
  Stream<List<WeekDays>> weekDays (collection, id, weekNumber) async* {
    yield* Firestore.instance.collection(collection).document(id).collection(weekNumber).snapshots().map(_daysListFromSnapshot);
  }

  // Week Day Workout Details from snapshot
  WeekDays _trainingDayDetailsfromSnapshot (DocumentSnapshot snapshot){
      return WeekDays(
        day: snapshot.data["Day"] ?? "",
        week: snapshot.data["Week"] ?? "",
        currentDayIndex: snapshot.data["Current Day Index"] ?? 1,
        maxDayIndex: snapshot.data["Max Day Index"] ?? 5,
        nextWeek: snapshot.data["Next Week"] ?? 'Done',
        nextDay: snapshot.data["Next Day"] ?? 'Done',
        nextTime: snapshot.data["Next Time"] ?? '45 min',
        focus: snapshot.data["Focus"] ?? "",
        time: snapshot.data["Time"] ?? "",
        bodyPart: snapshot.data["Body part"] ?? "",
        exercises: List.from(snapshot.data["Exercises"]) ?? [],
      );
  }

  // Week Day Workout Details Stream
  Stream <WeekDays> trainingDayDetails (collection, id, weekNumber, dayNumber) async*{
    yield* Firestore.instance.collection(collection).document(id).collection(weekNumber).document(dayNumber).snapshots().map(_trainingDayDetailsfromSnapshot);
  }

 //Workout Sets list from snapshot
  List<Workout> _workoutFromSnapshot (QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){ 
      return 
      Workout(
        rounds: doc.data["Rounds"] ?? "",
        stage: doc.data["Stage"] ?? 0,
        sets:  doc.data["Workout"].map<Exercise>((item){
          return Exercise(
            exerciseName: item['Description'] ?? '',
            reps: item['Reps'] ?? '',
            weight: item['Weight'] ?? '',
            duration: item['Duration'] ?? 0,
          );
        }).toList(),
      );
    }).toList();
  }

  //Get Workout Streams
  Stream<List<Workout>> dayWorkout (collection, id, weekNumber, dayNumber) async* {
    yield* Firestore.instance.collection(collection).document(id).collection(weekNumber).document(dayNumber).collection('Workout').snapshots().map(_workoutFromSnapshot);
  }



  // Exercise Detail from snapshot
  ExerciseDetail _exerciseDetailfromSnapshot (DocumentSnapshot snapshot){
      return ExerciseDetail(
        // description: snapshot.data['Description'] ?? '',
        // tips: snapshot.data['Tips'] ?? '', 
        video: snapshot.data['Video'] ?? '',
        image: snapshot.data['Image'] ?? '',      
        // tags: List.from(snapshot.data['Tags']) ?? [], 
        // equipment: List.from(snapshot.data['Equipment']) ?? [], 
      );
  }

  // Exercise Detail Stream
  Stream <ExerciseDetail> exerciseDetail (exercise) async*{
    yield* Firestore.instance.collection('Exercise List').document(exercise).snapshots().map(_exerciseDetailfromSnapshot);
  }



  // Record next workout from my plan
  Future updateUserWorkoutProgress (bool personalizedRoutine, String routineName, String nextTraingDay, String nextTrainingWeek, String nextTrainingDuration) async {

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    return await profile.document(uid).updateData({
      'Personalized Routine': personalizedRoutine ?? true,
      'Current Training Routine': routineName,
      'Current Training Day': nextTraingDay,
      'Current Training Week': nextTrainingWeek,
      'Current Training Duration': nextTrainingDuration,
    });
  }

  //Save to user Log Activity
  Future saveTrainingSession (String trainingType, String duration, String trainingSession,) async {

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    return await profile.document(uid).updateData({
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
        userActivityList: snapshot.data["Activity"].map<UserActivity>((item){
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
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    yield* profile.document(uid).snapshots().map(_activityLogfromSnapshot);
  }


  ProgressPictureList _progressPics (DocumentSnapshot snapshot){
    try{
      return ProgressPictureList(        
        progressPicturesList: snapshot.data["Progress Pictures"].map<ProgressPictures>((item){
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
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    yield* profile.document(uid).snapshots().map(_progressPics);
  }

  //Save Progress Picture
  Future saveProgressPicture (String image) async {

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    return await profile.document(uid).updateData({
      'Progress Pictures': FieldValue.arrayUnion([{
          'Image': image ?? '',
          'Date': DateTime.now() ?? '',
        }]
      ),       
    });
  }

  //Delete Progress Picture
  Future deleteProgressPicture (image, date) async {

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    return await profile.document(uid).updateData({
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
      return UserProfile(
        uid: snapshot.data['UID'] ?? '',
        name: snapshot.data['Name'] ?? '',
        about: snapshot.data['About'] ?? '',
        sex: snapshot.data['Sex'] ?? '', 
        weight: snapshot.data['Weight'] ?? '', 
        height: snapshot.data['Height'] ?? '', 
        preference: snapshot.data['Preference'] ?? '', 
        goal: snapshot.data['Goal'] ?? '', 
        experience: snapshot.data['Experience'] ?? '', 
        caloriesBurnt: snapshot.data['Calories Burnt'] ?? 0, 
        birthday: snapshot.data['Birthday'].toDate() ?? DateTime.parse("1994-01-01 12:00:00"),
        accumulatedHours: snapshot.data['Accumulated Hours'] ?? 0, 
        accumulatedWorkouts: snapshot.data['Accumulated Workouts'] ?? 0,
        profilePic: snapshot.data['Profile Image'] ?? 'https://firebasestorage.googleapis.com/v0/b/ludus-health-coach.appspot.com/o/Profile%20Images%2FNo%20User.png?alt=media&token=0312211c-026c-432b-98b5-e4e03bcbe386',

        level: snapshot.data['Level'] ?? 'Level 1',
        points: snapshot.data['Points'] ?? 0,
        levelFrom: snapshot.data['Level From'] ?? 0,
        levelTo: snapshot.data['Level To'] ?? 499,

        groups: snapshot.data['Groups'] ?? [],

        currentTrainingWeek: snapshot.data['Current Training Week'] ?? 'Week 1',
        currentTrainingDay: snapshot.data['Current Training Day'] ?? 'Day 1',
        currentTrainingDuration: snapshot.data['Current Training Duration'] ?? '',
        trainingRoutine: snapshot.data['Current Training Routine'] ?? '',
        personalizedRoutine: snapshot.data['Personalized Routine'] ?? true,

        hasPersonalCoach: snapshot.data['Personal Coach'] ?? false,
      );
  }

  // Profile Stream
  Stream <UserProfile> get userData async*{
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    yield* profile.document(uid).snapshots().map(_userDatafromSnapshot);
  }





  //Update User Stats
  Future updateUserStats (int workout, int caloriesBurnt, int hours, int points) async {

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    return await profile.document(uid).updateData({
     'Accumulated Workouts': workout,
      'Calories Burnt': caloriesBurnt,
      'Accumulated Hours': hours,
      'Points': points,
    });
  }

  Future updateUserPoints (int points) async {

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    return await profile.document(uid).updateData({
      'Points': points,
    });
  }






  //Update User Level
  Future updateUserLevel (level, levelFrom, levelTo) async {

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    return await profile.document(uid).updateData({
     'Level': level ?? 'Champion',
     'Level From': levelFrom ?? 40000,
     'Level To': levelTo ?? 100000,
    });
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
        created: doc.data['Created'].toDate() ?? DateTime.now(),
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








///////////////////////// Goals Streams from Firestore ////////////////////////// 

    // Personal Goal List from snapshot
  List<Goals> _goalListFromSnapshot (QuerySnapshot snapshot){
    try{
      return snapshot.documents.map((doc){
        return Goals(
          description: doc.data['Description'] ?? '',
          initialValue: doc.data['Initial Value'].toDouble() ?? 0, 
          targetValue: doc.data['Target Value'].toDouble() ?? 0,
          currentValue: doc.data['Current Value'].toDouble() ?? 0,
          stage: doc.data['Stage'] ?? 'In Progress',
          unit: doc.data['Unit'] ?? '',
          dateFrom: doc.data['DateFrom'].toDate(),
          dateTo: doc.data['DateTo'].toDate(),
          goalType: doc.data['Goal Type'] ?? '',
          milestones: doc.data['Milestones'].map<Milestones>((item){
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

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    yield* Firestore.instance.collection('Goals').document(uid).collection('My Goals').snapshots().map(_goalListFromSnapshot);
  }

  //Update Goal Progress
  Future updateGoalProgress (goal, currentValue) async {

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    return await Firestore.instance.collection('Goals').document(uid).collection('My Goals').document(goal).updateData({
     'Current Value': currentValue,
    });
  }

  //Create Goal
  Future createGoal (goal, initialValue, currentValue, targetValue, unit, dateTo, goalType, milestones) async {

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    return await Firestore.instance.collection('Goals').document(uid).collection('My Goals').document(goal).setData({
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

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    return await Firestore.instance.collection('Goals').document(uid).collection('My Goals').document(goal).delete();
  } 

  //Update Milestone Completion
  Future updateMilestone (String goal, List newList) async {

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    return await Firestore.instance.collection('Goals').document(uid).collection('My Goals').document(goal).updateData({
      'Milestones': newList     
    });
  }




///////////////////////// Chat Streams from Firestore ////////////////////////// 

  //Create First Chat Room
  Future createFirstChat(receiverUID, newDocID) async {

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    return await Firestore.instance.collection('Chat Rooms').document(newDocID).setData({
     'Created At': DateTime.now(),
     'Users': [uid, receiverUID],
     'User Reads': [
       {
       'User': uid ?? '',
       'Last Read': DateTime.now(),
      },
       {
       'User': receiverUID ?? '',
       'Last Read': DateTime.parse("1994-01-01 12:04:04"),
      },
     ]
    });
  }


  //Update MyLastRead
  Future deletePreviousLastRead (String docID, date) async {

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    return await Firestore.instance.collection('Chat Rooms').document(docID).updateData({
      'User Reads': FieldValue.arrayRemove([{
          'User': uid ?? '',
          'Last Read': date,
        }]
      ),       
    });
  }
  Future updateMyLastRead (String docID) async {

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    return await Firestore.instance.collection('Chat Rooms').document(docID).updateData({
      'User Reads': FieldValue.arrayUnion([{
          'User': uid ?? '',
          'Last Read': DateTime.now(),
        }]
      ),       
    });
  }


  //List of Chats
  List<ChatsList> _chatsListFromSnapshot (QuerySnapshot snapshot){
    try{
      return snapshot.documents.map((doc){
        return ChatsList(
          users: doc.data['Users'] ?? [],
          docID: doc.documentID,
          lastMessageTime: doc.data['Created At'].toDate(),
          userReads: doc.data['User Reads'].map<UserReads>((item){
            return UserReads(
              user: item['User'] ?? '',
              lastChecked: item['Last Read'].toDate() ?? DateTime.now(),            
            );
            }).toList(),
          );
        }
      ).toList();
    } catch (e){
      print(e);
      return null;
    }
    
  }

  // Chats Stream
  Stream <List<ChatsList>> get chatsList async*{

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    yield* Firestore.instance.collection('Chat Rooms').where('Users', arrayContains: uid).snapshots().map(_chatsListFromSnapshot);
  }

  // Profile from snapshot
  ChatsList _selectedChatfromSnapshot (DocumentSnapshot snapshot){
    try{
      return ChatsList(
        users: snapshot.data['Users'] ?? [],
        docID: snapshot.documentID,
        lastMessageTime: snapshot.data['Created At'].toDate(),
        userReads: snapshot.data['User Reads'].map<UserReads>((item){
          return UserReads(
            user: item['User'] ?? '',
            lastChecked: item['Last Read'].toDate() ?? DateTime.now(),        
          );
        }).toList(),
      );
    } catch (e){
      print(e);
      return null;
    }
  }

  // Profile Stream
  Stream <ChatsList> selectedChat (docID) async*{
    yield* Firestore.instance.collection('Chat Rooms').document(docID).snapshots().map(_selectedChatfromSnapshot);
  }



  //List of Chats
  List<SearchChatsList> _searchChatsListFromSnapshot (QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return SearchChatsList(
        users: doc.data['Users'] ?? [],
        docID: doc.documentID
        );
      }
    ).toList();
  }

  
  // Search User existing
  Stream <List<SearchChatsList>> searchChatsList (String searchUserID) async*{
    yield* Firestore.instance.collection('Chat Rooms').where('Users', arrayContains: searchUserID).snapshots().map(_searchChatsListFromSnapshot);
  }





  //List of Messages Chats
  List<Messages> _messagesListFromSnapshot (QuerySnapshot snapshot){
    try{
      return snapshot.documents.map((doc){
        return Messages(
          sender: doc.data['Sender'] ?? '',
          text: doc.data['Text'] ?? '',
          time: doc.data['Time'].toDate(),
          image: doc.data['Image'] ?? null,
          docID: doc.documentID,

          type: doc.data['Type'] ?? null,
          headline: doc.data['Headline'] ?? '',
          subtitle: doc.data['Subtitle'] ?? '',
          );
        }
      ).toList();
    } catch(e){
      print(e);
      return null;
    }
  }

  // Messages Stream
  Stream <List<Messages>> messages (docID) async*{

    yield* Firestore.instance.collection('Chat Rooms').document(docID).collection('Messages')
      .orderBy('Time', descending: true)
      .limit(10)
      .snapshots().map(_messagesListFromSnapshot);
  }


  //Create Message
  Future sendMessage(docID, text, image) async {

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    return await Firestore.instance.collection('Chat Rooms').document(docID).collection('Messages').document().setData({
     'Time': DateTime.now(),
     'Sender': uid,
     'Text': text,
     'Image': image,
    });
  }
  Future sendSharedMessage(docID, text, type, headline, subtitle) async {

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    return await Firestore.instance.collection('Chat Rooms').document(docID).collection('Messages').document().setData({
     'Time': DateTime.now(),
     'Sender': uid,
     'Text': text,
     'Image': null,
     'Type': type,
     'Headline': headline,
     'Subtitle': subtitle,
    });
  }

  //Update last message date
  Future updateChatDate(docID) async {

    return await Firestore.instance.collection('Chat Rooms').document(docID).updateData({
     'Created At': DateTime.now(),
    });
  }



  //List Chat Options (Users)
  List<UserProfile> _userListFromSnapshot (QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return UserProfile(
        name: doc.data['Name'] ?? '',
        uid: doc.data['UID'] ?? '',
        about: doc.data['About'] ?? '',
        profilePic: doc.data['Profile Image'] ?? 'https://firebasestorage.googleapis.com/v0/b/ludus-health-coach.appspot.com/o/Profile%20Images%2FNo%20User.png?alt=media&token=0312211c-026c-432b-98b5-e4e03bcbe386', 
        );
      }
    ).toList();
  }


  // Users Search
  Stream <List<UserProfile>> searchUsers (String userToSearch, int limitNumber) async*{
    yield* Firestore.instance.collection('User Profile').where('Search Name', arrayContains: userToSearch).limit(limitNumber).snapshots().map(_userListFromSnapshot);
  }




  //Delete Chat
  Future deleteChat (chatID) async {
    return await Firestore.instance.collection('Chat Rooms').document(chatID).delete();
  }
  Future removeFromMyChats (String docID) async {

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    return await Firestore.instance.collection('Chat Rooms').document(docID).updateData({
      'Users': FieldValue.arrayRemove([uid]),       
    });
  }




///////////////////////// Social Streams from Firestore ////////////////////////// 

  //List of Groups I Belong to
  List<Groups> _myGroupListFromSnapshot (QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Groups(
        groupName: doc.data['Group Name'] ?? 'None',
        groupSearchName: doc.data['Group Seach Name'] ?? [],
        groupImage: doc.data['Image'] ?? '',
        description: doc.data['Description'] ?? '',
        memberCount: doc.data['MemberCount'] ?? 0,
        private: doc.data['Private'] ?? false,
        members: doc.data['Members'] ?? [],
        admin: doc.data['Admin'] ?? '',
        createdAt: doc.data['Created At'].toDate() ?? DateTime.now(),
        );
      }
    ).toList();
  }

  // My Groups Stream
  Stream <List<Groups>> get myGroupList async*{
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    yield* Firestore.instance.collection('Groups').where('Members', arrayContains: uid).snapshots().map(_myGroupListFromSnapshot);
  }

  // Group Search
  Stream <List<Groups>> searchGroups (String groupToSearch) async*{
    yield* Firestore.instance.collection('Groups').where('Group Search Name', arrayContains: groupToSearch).snapshots().map(_myGroupListFromSnapshot);
  }



  // Groups from snapshot
  Groups _groupfromSnapshot (DocumentSnapshot snapshot){
      return Groups(
        groupName: snapshot.data['Group Name'] ?? 'None',
        groupSearchName: snapshot.data['Group Seach Name'] ?? [],
        groupImage: snapshot.data['Image'] ?? '',
        description: snapshot.data['Description'] ?? '',
        memberCount: snapshot.data['MemberCount'] ?? 0,
        private: snapshot.data['Private'] ?? false,
        members: snapshot.data['Members'] ?? [],
        admin: snapshot.data['Admin'] ?? [],
        createdAt: snapshot.data['Created At'].toDate() ?? DateTime.now(),
      );
  }

  // Groups Stream
  Stream <Groups> groupData (String groupName) async*{
    yield* Firestore.instance.collection('Groups').document(groupName).snapshots().map(_groupfromSnapshot);
  }



  // Create Group
  Future createGroup(groupName, groupImage, groupDescription, List groupSearchName) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    return await Firestore.instance.collection('Groups').document(groupName).setData({
      'Group Name': groupName,
      'Group Search Name': groupSearchName ?? [],
      'Image': groupImage ?? '',
      'Description': groupDescription ?? '',
      'MemberCount': 1,
      'Private': false,
      'Members': [uid],
      'Admin': uid ?? '',
      'Created At': DateTime.now(),
    });
  }



  // Group Feed
  List<Post> _feedFromSnapshot (QuerySnapshot snapshot){
    try {
      return snapshot.documents.map((doc){
        return Post(
          postID: doc.data['Post ID'],
          ownerUID: doc.data['Owner ID'],
          date: doc.data['Time'].toDate(),
          likes: doc.data['Likes'] ?? [],
          textContent: doc.data['Text Content'] ?? '',
          media: doc.data['Media'] ?? '',
          location: doc.data['Location'] ?? '',
          comments: doc.data["Comments"].map<PostComments>((item){
            return PostComments(
              userID: item['Sender'] ?? '',
              comment: item['Comment'] ?? '',            
            );
            }).toList(),

          type: doc.data['Type'] ?? null,
          headline: doc.data['Headline'] ?? '',
          subtitle: doc.data['Subtitle'] ?? '',
        );
      }).toList();
    } catch(e){
      return null;
    }
  }

  // Feed Stream
  Stream <List<Post>> groupFeed (groupName) async*{
    yield* Firestore.instance.collection('Groups').document(groupName).collection('Posts').orderBy('Time', descending: true).limit(15).snapshots().map(_feedFromSnapshot);
  }

  // Individual Post from snapshot (Comments)
  Post _postfromSnapshot (DocumentSnapshot snapshot){
    return Post(
        postID: snapshot.data['Post ID'] ?? '',
        ownerUID: snapshot.data['Owner ID'] ?? '',
        date: snapshot.data['Time'].toDate() ?? '',
        likes: snapshot.data['Likes'] ?? [],
        textContent: snapshot.data['Text Content'] ?? '',
        media: snapshot.data['Media'] ?? '',
        location: snapshot.data['Location'] ?? '',
        comments: snapshot.data["Comments"].map<PostComments>((item){
          return PostComments(
            userID: item['Sender'] ?? '',
            comment: item['Comment'] ?? '',
            time: item['Time'].toDate() ?? '',
          );
        }).toList(),
        
        type: snapshot.data['Type'] ?? null,
        headline: snapshot.data['Headline'] ?? '',
        subtitle: snapshot.data['Subtitle'] ?? '',
    );
  }

  // Individual Post Stream (Comments)
  Stream <Post> post (groupName, postID) async*{
    yield* Firestore.instance.collection('Groups').document(groupName).collection('Posts').document(postID).snapshots().map(_postfromSnapshot);
  }


  //Create Post
  Future createPost(groupName, textContent, media) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    String docID = DateTime.now().toString(); 

    return await Firestore.instance.collection('Groups').document(groupName).collection('Posts').document(docID).setData({
      'Post ID': docID,
      'Owner ID': uid,
      'Time': DateTime.now(),
      'Likes': [],
      'Text Content': textContent,
      'Media': media ?? '',
      'Comments': [],
    });
  }
  Future createSharedPost(groupName, textContent, type, headline, subtitle) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    String docID = DateTime.now().toString(); 

    return await Firestore.instance.collection('Groups').document(groupName).collection('Posts').document(docID).setData({
      'Post ID': docID,
      'Owner ID': uid,
      'Time': DateTime.now(),
      'Likes': [],
      'Text Content': textContent,
      'Media': '',
      'Comments': [],
      'Type': type,
      'Headline': headline,
      'Subtitle': subtitle,
    });
  }


  // Post Header Owner
  UserProfile _postOwnerfromSnapshot (DocumentSnapshot snapshot){
      return UserProfile(
        name: snapshot.data['Name'] ?? '',
        about: snapshot.data['About'] ?? '',
        uid: snapshot.data['UID'] ?? '',
        profilePic: snapshot.data['Profile Image'] ?? 'https://firebasestorage.googleapis.com/v0/b/ludus-health-coach.appspot.com/o/Profile%20Images%2FNo%20User.png?alt=media&token=0312211c-026c-432b-98b5-e4e03bcbe386',
      );
  }

  // Post Owner Stream
  Stream <UserProfile> postOwner(ownerID) async*{
    yield* profile.document(ownerID).snapshots().map(_postOwnerfromSnapshot);
  }


  //Interact with Post : Like/Unlike
  //Like
  Future likePost(groupName, postID) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return await Firestore.instance.collection('Groups').document(groupName).collection('Posts').document(postID).updateData({
      'Likes': FieldValue.arrayUnion([uid] ?? ''),
    });
  }

  //Unlike
  Future unlikePost(groupName, postID) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return await Firestore.instance.collection('Groups').document(groupName).collection('Posts').document(postID).updateData({
      'Likes': FieldValue.arrayRemove([uid] ?? ''),
    });
  }


  //Comment in Post
  Future commentPost(groupName, postID, commentText) async {

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    return await Firestore.instance.collection('Groups').document(groupName).collection('Posts').document(postID).updateData({
     'Comments': FieldValue.arrayUnion([{
          'Time': DateTime.now(),
          'Sender': uid,
          'Comment': commentText,
        }]
      ),     
    });
  }
  



  //Join a Group
  Future joinGroupList (String groupName, int memberCount) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return await Firestore.instance.collection('Groups').document(groupName).updateData({
      'Members': FieldValue.arrayUnion([uid] ?? ''),
      'MemberCount' : memberCount +1 ?? memberCount
    });
  }

  //Add to my Group
  Future addMyGroup (String groupName) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return await profile.document(uid).updateData({
      'Groups': FieldValue.arrayUnion([groupName] ?? ''),
    });
  }


  //Ask to Join Private Group
  Future askJoinPrivateGroup (String adminUID, String group) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return await profile.document(adminUID).updateData({
      'Group Notifications': FieldValue.arrayUnion([{
          'Notification Type': 'Join Request',  
          'Group': group ?? '',
          'Requester UID': uid ?? '',
          'Date': DateTime.now(),
        }]
      ),       
    });
  }

  //Accept in private group
  Future acceptinPrivateGroup (String requesterUID, String group) async {
    return await profile.document(requesterUID).updateData({
      'Group Notifications': FieldValue.arrayUnion([{
          'Notification Type': 'Join Request Accepted',  
          'Group': group ?? '',
          'Requester UID': requesterUID ?? '',
          'Date': DateTime.now(),
        }]
      ),       
    });
  }

  //Notify me likes and comments
  Future notifyLikesComments (String postOwnerUID, String likeorComment, String group) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return await profile.document(postOwnerUID).updateData({
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
        groupNotifications: snapshot.data["Group Notifications"].map<GroupNotifications>((item){
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
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    yield* profile.document(uid).snapshots().map(_groupNotificationsfromSnapshot);
  }
  
  //Sender Join a Group
  Future senderjoinGroupList (String senderID, String groupName, int memberCount) async {
    return await Firestore.instance.collection('Groups').document(groupName).updateData({
      'Members': FieldValue.arrayUnion([senderID] ?? ''),
      'MemberCount' : memberCount +1 ?? memberCount
    });
  }

  //Add to sender Group
  Future addSenderGroup (String senderID, String groupName) async {
    return await profile.document(senderID).updateData({
      'Groups': FieldValue.arrayUnion([groupName] ?? ''),
    });
  }

  //Delete Group Notification
  Future deleteGroupNotification (date, String group, String type, String senderUID) async {

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    return await profile.document(uid).updateData({
      'Group Notifications': FieldValue.arrayRemove([{
          'Date': date ?? '',
          'Group': group ?? '',
          'Notification Type': type ?? '',
          'Requester UID': senderUID ?? '',
        }]
      ),       
    });
  }

  //Leave a Group
  Future leaveGroupList (String groupName, int memberCount) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return await Firestore.instance.collection('Groups').document(groupName).updateData({
      'Members': FieldValue.arrayRemove([uid] ?? ''),
      'MemberCount' : memberCount -1 ?? memberCount
    });
  }

  //Delete from my Groups
  Future deleteMyGroup (String groupName) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return await profile.document(uid).updateData({
      'Groups': FieldValue.arrayRemove([groupName] ?? ''),
    });
  }







///////////////////////// Nutrition Recipes Streams from Firestore ////////////////////////// 

  // Recipes List
  List<Recipes> _recipesFromSnapshot (QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Recipes(
        name: doc.data['Name'] ?? '',
        image: doc.data['Image'] ?? '',
        author: doc.data['Author'] ?? '',
        intro: doc.data['Intro'] ?? '',
        time: doc.data['Time'] ?? '',
        category: doc.data['Category'] ?? '',
        directions: doc.data['Directions'] ?? [],
        tags: doc.data['Tags'] ?? [],
        ingredients: doc.data['Ingredients'] ?? [],
        likes: doc.data['Likes'] ?? [],
        recipeID: doc.documentID
      );
    }).toList();
  }

  // Recipes Stream
  Stream <List<Recipes>> reipes (String tag) async*{
    yield* Firestore.instance.collection('Recipes').where('Tags', arrayContains: tag).limit(10).snapshots().map(_recipesFromSnapshot);
  }

  // Saved Recipes Stream
  Stream <List<Recipes>> get savedRecipes async*{
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    yield* Firestore.instance.collection('Recipes').where('Likes', arrayContains: uid).limit(10).snapshots().map(_recipesFromSnapshot);
  }

  // Saved Recipes Stream
  Stream <List<Recipes>> get featuredRecipes async*{
    yield* Firestore.instance.collection('Recipes').where('Featured', isEqualTo:  true).limit(10).snapshots().map(_recipesFromSnapshot);
  }

  //Like
  Future likeRecipe(recipeID) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return await Firestore.instance.collection('Recipes').document(recipeID).updateData({
      'Likes': FieldValue.arrayUnion([uid] ?? ''),
    });
  }

  //Unlike
  Future unlikeRecipe(recipeID) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return await Firestore.instance.collection('Recipes').document(recipeID).updateData({
      'Likes': FieldValue.arrayRemove([uid] ?? ''),
    });
  }




}
