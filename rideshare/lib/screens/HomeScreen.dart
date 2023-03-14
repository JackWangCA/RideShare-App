import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rideshare/resources/AuthService.dart';
import 'package:rideshare/screens/Auth/ProfileScreen.dart';
import 'package:rideshare/screens/MyListingsScreen.dart';
import 'package:rideshare/screens/SettingScreen.dart';
import 'package:rideshare/models/user.dart' as model;

import 'CreateListingScreens/CreateListingScreen.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authUser = FirebaseAuth.instance.currentUser!;
  late StreamSubscription internetSubscription;
  bool hasInternet = true;
  bool isLoading = false;
  // String uid = "";
  // String email = "";
  // String firstName = "";
  // String lastName = "";
  // String photoUrl = "";
  bool hasPhoto = false;
  model.User user = model.User(
    uid: "uid",
    email: "email",
    firstName: "firstName",
    lastName: "lastName",
    listings: [],
  );

  @override
  void dispose() {
    internetSubscription.cancel();
    super.dispose();
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
    internetSubscription =
        InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() {
        this.hasInternet = hasInternet;
      });
    });
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
      // print(user.photoUrl);

      if (user.photoUrl.isEmpty) {
        setState(() {
          hasPhoto = false;
        });
      } else {
        setState(() {
          hasPhoto = true;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
            ),
          )
        : hasInternet
            ? Scaffold(
                appBar: AppBar(
                  title: Text(
                    "GETAWAY",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  actions: <Widget>[
                    IconButton(
                        onPressed: () {
                          if (authUser.emailVerified) {
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) => const CreateListingPage(),
                              ),
                            )
                                .then((value) {
                              setState(() {
                                getData();
                              });
                            });
                          } else {
                            showMessage(
                                "You have to verify your email address before making a post");
                          }
                        },
                        icon: const Icon(Icons.add))
                  ],
                ),

                //Drawer on the left side of the App Bar
                drawer: Drawer(
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 180,
                        child: DrawerHeader(
                          child: Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 80.0,
                                  height: 80.0,
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
                                  user.email,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                Text(
                                  authUser.emailVerified
                                      ? "Verified"
                                      : "Unverified",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      //User's Profile
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(
                          'My Profile',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) => const ProfilePage(),
                            ),
                          )
                              .then((value) {
                            setState(() {
                              getData();
                            });
                          });
                          ;
                        },
                      ),

                      //User's Listings
                      ListTile(
                        leading: const Icon(Icons.car_rental),
                        title: Text(
                          'My Listings',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MyListingsPage(),
                            ),
                          );
                        },
                      ),

                      //Settings
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: Text(
                          'Settings',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SettingsPage(),
                            ),
                          );
                        },
                      ),

                      //Sign Out
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: Text(
                          'Sign Out',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        onTap: () {
                          AuthService().signOut();
                        },
                      ),
                    ],
                  ),
                ),
                body: Center(
                  child: Text('Logged In As: ${authUser.email!}'),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  title: Text(
                    "GETAWAY",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                body: const Center(
                  child: Text("No Internet"),
                ),
              );
  }
}
