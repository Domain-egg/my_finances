import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_finances/models/User.dart';

/// The service where all the authentication is handled
///
/// The user can log in/out, sign up, the app knows who is logged in,
/// every time it checks this it checks also if the sum lof the entrys
/// is declared in the database if not it does it.

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);

  UserModel userModel = UserModel();
  final userRef = FirebaseFirestore.instance.collection("userData");

  //**checks if User changes**
  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  //**gets current UID**
  Future<String> getCurrentUID() async {
    var snapshotE = await FirebaseFirestore.instance
        .collection("userData")
        .doc(_firebaseAuth.currentUser.uid)
        .collection("sums")
        .doc("sumEntry")
        .get();

    if (!snapshotE.exists) {
      await FirebaseFirestore.instance
          .collection("userData")
          .doc(_firebaseAuth.currentUser.uid)
          .collection("sums")
          .doc("sumEntry")
          .set({
        'sumE': 0.00,
      });
    }

    var snapshotD = await FirebaseFirestore.instance
        .collection("userData")
        .doc(_firebaseAuth.currentUser.uid)
        .collection("sumsD")
        .doc("sumDepts")
        .get();

    if (!snapshotD.exists) {
      await FirebaseFirestore.instance
          .collection("userData")
          .doc(_firebaseAuth.currentUser.uid)
          .collection("sumsD")
          .doc("sumDepts")
          .set({
        'sumD': 0.00,
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

  //**add username to DB
  Future<void> addUserToDB(
      {String username, String email, DateTime timestamp}) async {
    userModel = UserModel(
        uid: _firebaseAuth.currentUser.uid,
        username: username,
        email: email,
        timestamp: timestamp);

    await userRef
        .doc(_firebaseAuth.currentUser.uid)
        .set(userModel.toMap(userModel));
  }

  //**gets user from DB by id
  Future<UserModel> getUserFromDB({String uid}) async {
    final DocumentSnapshot doc = await userRef.doc(uid).get();
    return UserModel.fromMap(doc.data());
  }

  //**checks if user exists**
  Future<bool> getUserExists({String username}) async {
    bool exists = false;
    try {
      await FirebaseFirestore.instance
          .collection("userData")
          .orderBy("username")
          .startAt([username]).endAt([username]).get().then((doc) {
        if (doc.size==0)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }
}
