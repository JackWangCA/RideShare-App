import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rideshare/models/listing.dart';
import 'package:rideshare/models/user.dart' as model;

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> publishPost(Listing listing) async {
    String result = "Some error occurred, please try again later.";
    if (listing.uid.isNotEmpty &&
        listing.uuid.isNotEmpty &&
        listing.startLocationText.isNotEmpty &&
        listing.destinationText.trim().isNotEmpty) {
      try {
        User currentUser = _auth.currentUser!;
        DocumentSnapshot documentSnapshot =
            await _firestore.collection('users').doc(currentUser.uid).get();
        model.User user = model.User.fromSnap(documentSnapshot);
        user.listings.add(listing.uuid);
        _firestore.collection("users").doc(user.uid).set(user.toJson());
        await _firestore
            .collection("posts")
            .doc(listing.uuid)
            .set(listing.toJson());
        result = "success";
      } catch (e) {
        result = e.toString();
      }
    }
    return result;
  }

  Future<Listing> getPostFromUUID(String uuid) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('posts').doc(uuid).get();
    return Listing.fromSnap(documentSnapshot);
  }

  Future<Query<Map<String, dynamic>>> getDocuments() async {
    Query<Map<String, dynamic>> query = _firestore
        .collection("posts")
        .orderBy("publishedTime", descending: true);
    return query;
  }

  Future<Query<Map<String, dynamic>>> getUserPosts(String uid) async {
    Query<Map<String, dynamic>> query = _firestore
        .collection("posts")
        .where("uid", isEqualTo: uid)
        .orderBy("departTime", descending: true);
    return query;
  }

  Future<Query<Map<String, dynamic>>> getAllPostsByTime() async {
    Query<Map<String, dynamic>> query = _firestore
        .collection("posts")
        .where("departTime", isGreaterThan: DateTime.now())
        .orderBy("departTime")
        .orderBy("publishedTime", descending: true);
    return query;
  }

  Future<Query<Map<String, dynamic>>> getAllPostsByNameStart() async {
    Query<Map<String, dynamic>> query = _firestore
        .collection("posts")
        .where("departTime", isGreaterThan: DateTime.now())
        .orderBy("departTime")
        .orderBy("startLocationText", descending: true);
    return query;
  }

  Future<Query<Map<String, dynamic>>> getAllPostsByOffering() async {
    Query<Map<String, dynamic>> query = _firestore
        .collection("posts")
        .where("departTime", isGreaterThan: DateTime.now())
        .orderBy("departTime")
        .where("listingType", isEqualTo: "Offering");
    return query;
  }

  Future<Query<Map<String, dynamic>>> getAllPostsByRequesting() async {
    Query<Map<String, dynamic>> query = _firestore
        .collection("posts")
        .where("departTime", isGreaterThan: DateTime.now())
        .orderBy("departTime")
        .where("listingType", isEqualTo: "Request");
    return query;
  }

  // Future<List<Listing>> getUserPostsFromUID(String uid) async {
  //   List<Listing> myListings = [];
  //   var userQuery = await _firestore.collection("users").doc(uid).get();
  //   final docs = userQuery.get("listings");
  //   for (final doc in docs) {
  //     myListings.add(await getPostFromUUID(doc));
  //   }
  //   return myListings;
  // }

  Future<List<Listing>> getListingsFromDocs(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) async {
    List<Listing> myListings = [];
    for (final listing in docs) {
      Listing curListing = await getPostFromUUID(listing.data()["uuid"]);
      myListings.add(curListing);
    }
    return myListings;
  }
}
