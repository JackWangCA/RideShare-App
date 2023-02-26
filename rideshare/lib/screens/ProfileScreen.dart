import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:rideshare/models/user.dart' as model;
import 'package:rideshare/screens/EditProfileScreen.dart';

import '../components/myButton.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authUser = FirebaseAuth.instance.currentUser!;
  model.User user = model.User(
    uid: "",
    email: "",
    firstName: "",
    lastName: "",
    listings: [],
  );
  // String uid = "";
  // String email = "";
  // String firstName = "";
  // String lastName = "";
  // String bio = "";
  // String photoUrl = "";
  bool hasPhoto = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

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
        // bio = user.bio;
        // firstName = user.firstName;
        // lastName = user.lastName;
        // photoUrl = user.photoUrl;
      });

      if (user.photoUrl.isEmpty) {
        hasPhoto = false;
      } else {
        hasPhoto = true;
      }
    } catch (e) {
      print(e);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: Text(
          "Profile",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const Spacer(),
              SizedBox(
                width: 120.0,
                height: 120.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: hasPhoto
                      ? Image.network(
                          user.photoUrl,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'lib/images/default_photo.jpeg',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                user.firstName + " " + user.lastName,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                user.email.isEmpty ? "No email" : user.email,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(authUser.emailVerified ? "Verified" : "Unverified"),
              Text(
                user.bio.isEmpty ? "No bio" : user.bio,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(user.isCollegeStudent
                  ? "College Student"
                  : "Not College Student"),
              const Spacer(),
              MyButton(
                child: Text(
                  "Edit Profile",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).canvasColor, fontSize: 15.0),
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(),
                    ),
                  )
                      .then((value) {
                    setState(() {
                      getData();
                    });
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
