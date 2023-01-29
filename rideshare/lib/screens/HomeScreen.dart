import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rideshare/screens/SettingScreen.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                user.email!,
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
                signUserOut();
              },
            ),
          ],
        ),
      ),
      body: Center(child: Text('Logged In As: ${user.email!}')),
    );
  }
}
