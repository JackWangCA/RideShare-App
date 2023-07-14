import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:rideshare/resources/PostService.dart';
import 'package:rideshare/models/user.dart' as model;
import '../models/listing.dart';

class ListingDetailsPage extends StatefulWidget {
  final String uuid;
  const ListingDetailsPage({super.key, required this.uuid});

  @override
  State<ListingDetailsPage> createState() => _ListingDetailsPageState();
}

class _ListingDetailsPageState extends State<ListingDetailsPage> {
  User authUser = FirebaseAuth.instance.currentUser!;
  String uuid = "";
  Listing listing = Listing(
      departTime: DateTime(404),
      publishedTime: DateTime(404),
      startLocationText: "404");
  bool isLoading = false;
  bool hasPhoto = false;
  model.User user = model.User(
    uid: "uid",
    email: "email",
    firstName: "firstName",
    lastName: "lastName",
    listings: [],
    savedListings: [],
  );

  @override
  void initState() {
    super.initState();
    uuid = widget.uuid;
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    authUser = FirebaseAuth.instance.currentUser!;
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(authUser.uid)
          .get();
      setState(() {
        user = model.User.fromSnap(userSnap);
      });

      if (user.photoUrl.isEmpty) {
        setState(() {
          hasPhoto = false;
        });
      } else {
        setState(() {
          hasPhoto = true;
        });
      }
      Listing gotListing = await PostService().getPostFromUUID(uuid);
      setState(() {
        listing = gotListing;
        isLoading = false;
      });
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            appBar: AppBar(
              title: const Text("Listing Details"),
            ),
            body: const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text("Listing Details"),
            ),
            body: listing.departTime.year == 404
                ? Center(
                    child: Text(
                        "The post you are trying to view is unavailable at the moment."),
                  )
                : Center(
                    child: Text("Loaded"),
                  ),
            bottomNavigationBar: BottomAppBar(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.delete),
                    tooltip: "Delete",
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.call))
                ],
              ),
            ),
          );
  }
}
