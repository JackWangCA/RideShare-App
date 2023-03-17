import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:rideshare/components/myListingCard.dart';
import 'package:rideshare/models/user.dart' as model;
import 'package:rideshare/resources/PostService.dart';

import '../models/listing.dart';

class MyListingsPage extends StatefulWidget {
  const MyListingsPage({super.key});

  @override
  State<MyListingsPage> createState() => _MyListingsPageState();
}

class _MyListingsPageState extends State<MyListingsPage> {
  bool isLoading = false;
  User authUser = FirebaseAuth.instance.currentUser!;
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
    authUser = FirebaseAuth.instance.currentUser!;

    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(authUser.uid)
          .get();
      setState(() {
        user = model.User.fromSnap(userSnap);
      });
      var listingsFromUID =
          await PostService().getListingsFromUID(authUser.uid);
      setState(() {
        listings = listingsFromUID;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void showMessage(String title) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            contentPadding: const EdgeInsets.all(10.0),
            title: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    try {
      getData();
    } catch (e) {
      showMessage(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            appBar: AppBar(
              title: Text("Loading",
                  style: Theme.of(context).textTheme.titleLarge),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("My Listings",
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: listings.length,
                        itemBuilder: (context, index) {
                          return MyListingCard(
                              listing: listings.elementAt(index), onTap: () {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
