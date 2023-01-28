import 'package:flutter/material.dart';
import 'package:rideshare/screens/SettingScreen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                "L O G O",
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SettingsPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}