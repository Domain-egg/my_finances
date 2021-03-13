import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// The service where all the authentication is handled
///
/// The user can log in/out, sign up, the app knows who is logged in,
/// every time it checks this it checks also if the sum lof the entrys
/// is declared in the database if not it does it.

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);

  //**checks if User changes**
  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  //**gets current UID**
  Future<String> getCurrentUID() async {
    var snapshot = await FirebaseFirestore.instance
        .collection("userData")
        .doc(_firebaseAuth.currentUser.uid)
        .collection("sums")
        .doc("sumEntry")
        .get();

    if (!snapshot.exists) {
      await FirebaseFirestore.instance
          .collection("userData")
          .doc(_firebaseAuth.currentUser.uid)
          .collection("sums")
          .doc("sumEntry")
          .set({
        'sumE': 0.00,
      });
    }

    return (await _firebaseAuth.currentUser.uid);
  }

  //**logs out User**
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  //**logs in User**
  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //**registers a new user**
  Future<String> signUp({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
