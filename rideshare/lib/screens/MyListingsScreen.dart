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
  bool allFetched = false;
  DocumentSnapshot? lastDocument;
  static const PAGE_SIZE = 7;

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

  Future<void> getData() async {
    authUser = FirebaseAuth.instance.currentUser!;
    if (isLoading) {
      return;
    }
    if (allFetched) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(authUser.uid)
          .get();
      setState(() {
        user = model.User.fromSnap(userSnap);
      });
      Query<Map<String, dynamic>> query = await PostService().getDocuments();
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument!).limit(PAGE_SIZE);
      } else {
        query = query.limit(PAGE_SIZE);
      }
      final List<Listing> pagedData = await query.get().then((value) async {
        if (value.docs.isNotEmpty) {
          lastDocument = value.docs.last;
        } else {
          lastDocument = null;
        }
        var result = await PostService().getListingsFromDocs(value.docs);
        return result;
      });
      setState(() {
        listings.addAll(pagedData);
        if (pagedData.length < PAGE_SIZE) {
          allFetched = true;
        }
        isLoading = false;
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
    try {
      getData();
    } catch (e) {
      showMessage(e.toString());
    }
  }

  Future refresh() async {}

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
      body: Column(
        children: [
          Expanded(
            child: NotificationListener<ScrollEndNotification>(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: listings.length + 1,
                itemBuilder: (context, index) {
                  if (index == listings.length) {
                    if (!allFetched) {
                      return Container(
                        width: double.infinity,
                        height: 60,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        ),
                      );
                    } else {
                      return SizedBox(
                        child: Center(
                          child: Text("That's the end of the listings"),
                        ),
                      );
                    }
                  }
                  return MyListingCard(
                      listing: listings.elementAt(index), onTap: () {});
                },
              ),
              onNotification: (scrollEnd) {
                if (scrollEnd.metrics.atEdge && scrollEnd.metrics.pixels > 0) {
                  getData();
                }
                return true;
              },
            ),
          ),
        ],
      ),
    );
  }
}
