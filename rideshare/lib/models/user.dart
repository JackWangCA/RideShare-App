import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rideshare/models/listing.dart';

class User {
  String uid;
  String email;
  String bio;
  String photoUrl;
  String firstName;
  String lastName;
  String phoneNumber;
  List listings;
  List savedListings;
  bool isCollegeStudent;

  User({
    required this.uid,
    required this.email,
    this.bio = "",
    this.photoUrl = "",
    required this.firstName,
    required this.lastName,
    this.phoneNumber = "",
    required this.listings,
    required this.savedListings,
    this.isCollegeStudent = false,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      uid: snapshot["uid"],
      email: snapshot["email"],
      bio: snapshot["bio"],
      photoUrl: snapshot["photoUrl"],
      firstName: snapshot["firstName"],
      lastName: snapshot["lastName"],
      phoneNumber: snapshot["phoneNumber"],
      listings: snapshot["listings"],
      savedListings: snapshot["savedListings"],
      isCollegeStudent: snapshot["isCollegeStudent"],
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "bio": bio,
        "photoUrl": photoUrl,
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "listings": listings,
        "savedListings": savedListings,
        "isCollegeStudent": isCollegeStudent,
      };
}
