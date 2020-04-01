import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_trainer/Models/user.dart';
import 'package:personal_trainer/Models/weeks.dart';


class DatabaseService {

  final String uid;
  DatabaseService({this.uid});


  //Collection reference
  final CollectionReference routine = Firestore.instance.collection('Training Routine');
  //Collection reference
  final CollectionReference profile = Firestore.instance.collection('User Profile');

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

  //Weeks list from snapshot
  List<Weeks> _weekListFromSnapshot (QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){ 
      return 
      Weeks(
        number: doc.data["number"] ?? "",
      );
    }).toList();
  }

  //Get Workout Streams
  Stream<List<Weeks>> get week {
    return routine.snapshots()
    .map(_weekListFromSnapshot);
  }


////////// UserData to get User document in firestore

// User data from snapshot

UserData _userDataFromSnapshot (DocumentSnapshot snapshot){
  return UserData(
    uid: uid,
    days: snapshot.data['Days']
    );
}

 //Get user doc Streams
  Stream<UserData> get userData {
    return routine.document(uid).snapshots()
    .map(_userDataFromSnapshot);
  }


}