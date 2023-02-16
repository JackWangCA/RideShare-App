import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rideshare/models/user.dart' as model;

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //check if name field has correct format
  bool firstnameFormatCorrect(String firstName) {
    if (firstName.trim().isNotEmpty &&
        firstName.trim().length >= 2 &&
        firstName.trim().length < 15) {
      return true;
    } else {
      return false;
    }
  }

  bool lastnameFormatCorrect(String lastName) {
    if (lastName.trim().isNotEmpty &&
        lastName.trim().length >= 2 &&
        lastName.trim().length < 15) {
      return true;
    } else {
      return false;
    }
  }

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  Future<String> signUserUp({
    required String email,
    required String password,
    required String confirmPassword,
    required String firstName,
    required String lastName,
  }) async {
    String result = "Some error occurred, please try again later.";
    if (email.isNotEmpty &&
        firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        firstnameFormatCorrect(firstName) &&
        lastnameFormatCorrect(lastName) &&
        password.trim() == confirmPassword.trim()) {
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
        if (e.code == 'weak-password') {
          result = "Come on! You can come up with a better password!";
        } else if (e.code == "network-request-failed") {
          result = "No internet connection. Please try again later.";
        }
        //invalid email
        else if (e.code == 'invalid-email') {
          result = "Hmmm, that email doesn't look right....";
        }
        //email already in use
        else if (e.code == 'email-already-in-use') {
          result = "You already signed up with that email. Go sign in!";
        }
        //bad network connection
        else if (e.code == 'network-request-failed') {
          result = "Can't connect to internet, please check your connection!";
        }
      }
    } else if (password.trim() != confirmPassword.trim()) {
      result = "The two passwords do not match";
    } else if (email.trim().isEmpty ||
        firstName.trim().isEmpty ||
        lastName.trim().isEmpty ||
        password.trim().isEmpty ||
        confirmPassword.trim().isEmpty) {
      result = "You still need to fill some more info!";
    } else if (!firstnameFormatCorrect(firstName.trim()) ||
        !lastnameFormatCorrect(lastName.trim())) {
      result = "The name is a little too long (or too short), try again.";
    }
    return result;
  }

  Future<String> signUserIn({
    required String email,
    required String password,
  }) async {
    String result = "Some error occurred, please try again later.";
    if (email.trim().isNotEmpty && password.trim().isNotEmpty) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );
        result = "success";
      } on FirebaseAuthException catch (e) {
        //No user found
        if (e.code == 'user-not-found') {
          result = "Seems like you haven't signed up yet";
        } else if (e.code == "network-request-failed") {
          result = "No internet connection. Please try again later.";
        }
        //Weak-Password
        else if (e.code == 'wrong-password') {
          result = "Wrong Password. Maybe try again?";
        }
        //invalid email
        else if (e.code == 'invalid-email') {
          result = "Hmmm, that email doesn't look right....";
        }
        //email already in use
        else if (e.code == 'user-disabled') {
          result =
              "Your account has been suspended. Contact support at xxxxxx@gmail.com";
        } else {
          result = e.code;
        }
      }
    } else {
      result = "Some fields are left empty, please try again.";
    }
    return result;
  }

  Future<String> updateUserDetails(
      {required String firstName,
      required String lastName,
      required String bio,
      required String photoUrl}) async {
    String result = "Some error occurred, please try again later";
    if (firstnameFormatCorrect(firstName) && lastnameFormatCorrect(lastName)) {
      try {
        User currentUser = _auth.currentUser!;
        DocumentSnapshot documentSnapshot =
            await _firestore.collection('users').doc(currentUser.uid).get();
        model.User user = model.User.fromSnap(documentSnapshot);
        user.firstName = firstName.trim();
        user.lastName = lastName.trim();
        user.bio = bio.trim();
        user.photoUrl = photoUrl;

        // adding user in our database
        try {
          _firestore.collection("users").doc(user.uid).set(user.toJson());
        } catch (e) {
          print(e.toString());
        }

        result = "success";
      } catch (e) {
        result = e.toString();
      }
    } else {
      result = "Some fields are left empty, please try again.";
    }
    return result;
  }

  Future<String> deleteUser() async {
    String result = "There has been some problems, try again later.";
    if (_auth.currentUser != null) {
      try {
        String uid = _auth.currentUser!.uid;
        DocumentSnapshot documentSnapshot = await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .get();
        model.User user = model.User.fromSnap(documentSnapshot);
        await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .delete();

        if (user.photoUrl.isNotEmpty) {
          Reference ref =
              FirebaseStorage.instance.ref().child("Profile Images").child(uid);
          await ref.delete();
        }
        await _auth.currentUser!.delete();
        result = "success";
      } catch (e) {
        result = e.toString();
      }
    }
    return result;
  }

  Future<String> updatePassword({
    required String newPassword,
    required String confirmPassword,
  }) async {
    String result = "There has been some problems, try again later.";
    if (_auth.currentUser != null &&
        newPassword.trim() == confirmPassword.trim()) {
      try {
        await _auth.currentUser!.updatePassword(newPassword);
        result = "success";
      }
      //server side problems
      on FirebaseAuthException catch (e) {
        //weak passwrod
        if (e.code == "weak-password") {
          result = "Come on! You can come up with a better password!";
        }
        //need to log in within a certain period
        else if (e.code == "requires-recent-login") {
          result =
              "It's been too long since your last login, try logging in again and then change your password.";
        }
        //return error code otherwise
        else {
          result = e.toString();
        }
      }
    } else if (newPassword.trim() != confirmPassword.trim()) {
      result = "The two passwords do not match.";
    }
    return result;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
