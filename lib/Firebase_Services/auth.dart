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
    return (await _auth.currentUser()).uid;
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
  Future registerWithEmailAndPassword(String email, String password, String name, List searchName) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      await DatabaseService(uid: user.uid).createUserRoutine('Day 1');
      await DatabaseService(uid: user.uid).createUserProfile(name, searchName);

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