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
  bool isLoading = false;

  String uid = "";
  String email = "";
  String firstName = "";
  String lastName = "";
  String bio = "";
  String photoUrl = "";
  bool emailVerified = false;
  String phoneNumber = "";
  bool phoneVerified = false;
  bool hasPhoto = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(authUser.uid)
          .get();

      // // get post lENGTH
      // var postSnap = await FirebaseFirestore.instance
      //     .collection('posts')
      //     .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      //     .get();

      model.User user = model.User.fromSnap(userSnap);
      uid = user.uid;
      email = user.email;
      bio = user.bio;
      emailVerified = user.emailVerified;
      firstName = user.firstName;
      lastName = user.lastName;
      photoUrl = user.photoUrl;
      phoneNumber = user.phoneNumber;
      phoneVerified = user.phoneVerified;
      if (photoUrl.isEmpty) {
        hasPhoto = false;
      } else {
        hasPhoto = true;
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
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
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  SizedBox(
                    width: 120.0,
                    height: 120.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: hasPhoto
                          ? Image.network(photoUrl)
                          : Image.asset('lib/images/default_photo.jpeg'),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "$firstName $lastName",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    email,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    emailVerified ? "Email Verified" : "Email Unverified",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    phoneNumber.isEmpty ? "No Phone Number" : phoneNumber,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    phoneVerified ? "Phone Verified" : "Phone Unverified",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    bio.isEmpty ? "No bio" : bio,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    text: "Edit Profile",
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
        ),
      ),
    );
  }
}
