import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);

  //**checks if User changes**
  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  //**gets current UID**
  Future<String> getCurrentUID() async {
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
