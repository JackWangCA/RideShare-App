import 'package:flutter/material.dart';
import 'package:rideshare/settings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            DrawerHeader(
              child: Center(
                  child: Text(
                "L O G O",
                style: Theme.of(context).textTheme.titleLarge,
              )),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                'My Listings',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              onTap: () {
                null;
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                'Settings',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
