import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/user.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String name;

  //create user object based on firebase user
  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uid: user.uid) : null;
  }

  //Get UID for Firestore collection calls
  Future<String>getcurrentUID() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return uid;
  }


  //Auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
    .map(_userFromFirebaseUser);
  }

  //Sign in anonymously
  Future signInAnon() async {
    try{
     AuthResult result = await _auth.signInAnonymously();
     FirebaseUser user = result.user;
     return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString()); 
      return null;
    }

  }

  //Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e){
      print(e.toString()); 
      return null;
    }
  }


  //Register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      //Create new database doc with uid
      //await DatabaseService(uid: user.uid).updateUserData(name,'Sex', '00', '0.0', '0.0', 'None', 'None', 'None',0,0,0);
      await DatabaseService(uid: user.uid).createUserRoutine([1,2,3,4]);

      return _userFromFirebaseUser(user);
    } catch(e){
      print(e.toString()); 
      return null;
    }
  }


  //Sing Out
  Future signOut () async {
    try{
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }

  }

}