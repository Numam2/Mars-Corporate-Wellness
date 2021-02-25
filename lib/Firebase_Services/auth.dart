import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/user.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String name;

  //create user object based on firebase user
  AppUser _userFromFirebaseUser(User user){
    return user != null ? AppUser(uid: user.uid) : null;
  }

  //Get UID for Firestore collection calls
  Future<String>getcurrentUID() async {
    return (_auth.currentUser).uid;
  }


  //Auth change user stream
  Stream<AppUser> get user {
    return _auth.authStateChanges()
    .map(_userFromFirebaseUser);
  }

  //Sign in anonymously
  Future signInAnon() async {
    try{
     UserCredential result = await _auth.signInAnonymously();
     User user = result.user;
     return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString()); 
      return null;
    }

  }

  //Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {

    try {  

      User user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: email,password: password)).user;
        
        if(user != null){
          print('User is ${user.uid}');
          // Navigator.push(context, MaterialPageRoute(
            //   builder: (context) => InicioNew()));                            
        }

      // await _auth.signInWithEmailAndPassword(
      //   email: email,
      //   password: password);

      //  User user = (await _auth.signInWithEmailAndPassword(
      //   email: email,
      //   password: password)).user;
      // return _userFromFirebaseUser(user);

    } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
        
    } catch(e){
      print(e.toString()); 
      return null;
    }
              
  }


  //Register with email and password
  Future registerWithEmailAndPassword(String email, String password, String name, List searchName) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;

      // await DatabaseService(uid: user.uid).createUserRoutine('Day 1');
      // await DatabaseService(uid: user.uid).createUserProfile(name, searchName);

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