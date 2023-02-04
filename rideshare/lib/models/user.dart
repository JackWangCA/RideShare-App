import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rideshare/models/listing.dart';

class User {
  String uid;
  String email;
  String bio;
  bool emailVerified;
  String firstName;
  String lastName;
  String phoneNumber;
  bool phoneVerified;
  List listings;

  User({
    required this.uid,
    required this.email,
    this.bio = "",
    this.emailVerified = false,
    required this.firstName,
    required this.lastName,
    this.phoneNumber = '',
    this.phoneVerified = false,
    required this.listings,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      uid: snapshot["uid"],
      email: snapshot["email"],
      emailVerified: snapshot["emailVerified"],
      firstName: snapshot["firstName"],
      lastName: snapshot["lastName"],
      phoneNumber: snapshot["phoneNumber"],
      phoneVerified: snapshot["phoneVerified"],
      listings: snapshot["listings"],
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "emailVerified": emailVerified,
        "bio": bio,
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "phoneVerified": phoneVerified,
        "listings": listings,
      };
}
