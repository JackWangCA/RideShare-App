import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rideshare/models/user.dart' as model;

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  Future<String> signUserUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    String result = "Some error occurred, please try again later";
    if (email.isNotEmpty && firstName.isNotEmpty && lastName.isNotEmpty) {
      try {
        UserCredential cred =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );
        model.User user = model.User(
          uid: cred.user!.uid,
          email: email,
          firstName: firstName,
          lastName: lastName,
          listings: [],
        );

        // adding user in our database
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());

        result = "success";
      } on FirebaseAuthException catch (e) {
        result = e.code;
      }
    } else {
      result = "Some fields are left empty, please try again";
    }
    return result;
  }

  Future<String> signUserIn({
    required String email,
    required String password,
  }) async {
    String result = "Some error occurred, please try again later";
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );
        result = "success";
      } on FirebaseAuthException catch (e) {
        result = e.code;
      }
    } else {
      result = "Some fields are left empty, please try again";
    }
    return result;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
