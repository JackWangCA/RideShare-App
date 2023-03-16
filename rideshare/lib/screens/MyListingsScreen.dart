import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:rideshare/models/user.dart' as model;
import 'package:rideshare/resources/PostService.dart';

import '../models/listing.dart';

class MyListingsPage extends StatefulWidget {
  const MyListingsPage({super.key});

  @override
  State<MyListingsPage> createState() => _MyListingsPageState();
}

class _MyListingsPageState extends State<MyListingsPage> {
  final authUser = FirebaseAuth.instance.currentUser!;
  model.User user = model.User(
    uid: "uid",
    email: "email",
    firstName: "firstName",
    lastName: "lastName",
    listings: [],
    savedListings: [],
  );
  List<Listing> listings = [];

  getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(authUser.uid)
          .get();
      setState(() {
        user = model.User.fromSnap(userSnap);
        // uid = user.uid;
        // email = user.email;
        // firstName = user.firstName;
        // lastName = user.lastName;
        // photoUrl = user.photoUrl;
      });
      user.listings = await PostService().getListingsFromUID(authUser.uid);
      print(user.listings.length);
      // print(user.photoUrl);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("My Listings", style: Theme.of(context).textTheme.titleLarge),
      ),
    );
  }
}
