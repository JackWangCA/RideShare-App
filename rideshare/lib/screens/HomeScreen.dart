import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rideshare/resources/AuthService.dart';
import 'package:rideshare/screens/SettingScreen.dart';
import 'package:rideshare/models/user.dart' as model;

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authUser = FirebaseAuth.instance.currentUser!;
  String uid = "";
  String email = "";
  String firstName = "";
  String lastName = "";
  bool isLoading = false;
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
      firstName = user.firstName;
      lastName = user.lastName;
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'Ride',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            drawer: Drawer(
              child: ListView(
                children: [
                  //Logo in Drawer
                  DrawerHeader(
                    child: Center(
                        child: Text(
                      firstName,
                      style: Theme.of(context).textTheme.titleLarge,
                    )),
                  ),
                  //User's Listings
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(
                      'My Listings',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    onTap: () {
                      null;
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
            body: Center(child: Text('Logged In As: ${authUser.email!}')),
          );
  }
}
