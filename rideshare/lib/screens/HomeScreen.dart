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

import '../components/myListingCard.dart';
import '../models/listing.dart';
import '../resources/PostService.dart';
import 'CreateListingScreens/CreateListingScreen.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User authUser = FirebaseAuth.instance.currentUser!;
  late StreamSubscription internetSubscription;
  bool hasInternet = true;
  bool isLoading = false;
  bool emailVerified = false;
  List<Listing> listings = [];

  List<String> arrangeListingsOptions = <String>[
    'Newest',
    'Name(Start)',
    "Offering",
    "Requesting"
  ];
  String arrangeListing = "Newest";

  bool allFetched = false;
  DocumentSnapshot? lastDocument;
  static const PAGE_SIZE = 7;

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
    try {
      getData();
    } catch (e) {
      showMessage(e.toString());
    }
  }

  void resetPage() {
    setState(() {
      listings.clear();
      allFetched = false;
      lastDocument = null;
    });
  }

  getData() async {
    if (isLoading) {
      return;
    }
    if (allFetched) {
      return;
    }
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
      List<Listing> pagedData = [];
      pagedData = await getPostsBy(arrangeListing);
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
    setState(() {
      isLoading = false;
    });
  }

  Future<List<Listing>> getPostsBy(String arrangeMethod) async {
    var query;
    if (arrangeMethod == "Name(Start)") {
      query = await PostService().getAllPostsByNameStart();
    } else if (arrangeMethod == "Newest") {
      query = await PostService().getAllPostsByTime();
    } else if (arrangeMethod == "Offering") {
      query = await PostService().getAllPostsByOffering();
    } else if (arrangeMethod == "Requesting") {
      query = await PostService().getAllPostsByRequesting();
    }

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
    return pagedData;
  }

  Future<List<Listing>> getPostsByTime() async {
    var query = await PostService().getAllPostsByTime();
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
    return pagedData;
  }

  @override
  Widget build(BuildContext context) {
    return hasInternet
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                "GETAWAY",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              actions: <Widget>[
                DropdownButton(
                    value: arrangeListing,
                    items: arrangeListingsOptions
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        arrangeListing = value!;
                        resetPage();
                        getData();
                      });
                    }),
              ],
            ),
            floatingActionButton: FloatingActionButton(
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
              child: const Icon(Icons.add),
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
                              "${user.firstName} ${user.lastName}",
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
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                          builder: (context) => MyListingsPage(),
                        ),
                      )
                          .then((value) {
                        setState(() {
                          getData();
                        });
                      });
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
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ),
                      )
                          .then((value) {
                        setState(() {
                          getData();
                        });
                      });
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
            body: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
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
                        if (scrollEnd.metrics.atEdge &&
                            scrollEnd.metrics.pixels > 0) {
                          getData();
                        }
                        return true;
                      },
                    ),
                  ),
                ],
              ),
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
