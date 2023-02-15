import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rideshare/resources/AuthService.dart';
import 'package:rideshare/screens/AccountDeleteScreen.dart';
import 'package:rideshare/screens/ChangePasswordScreen.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:rideshare/components/themeProvider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SettingsList(
        sections: [
          //Common Settings
          SettingsSection(
            title: Text(
              'Common',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            tiles: <SettingsTile>[
              //Follow System Theme
              SettingsTile.switchTile(
                onToggle: (value) {
                  themeProvider.changeSystemTheme(value);
                },
                initialValue: themeProvider.isSystem,
                leading: const Icon(Icons.format_paint),
                title: Text(
                  'Follow System Theme',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              //Dark Theme or no
              SettingsTile.switchTile(
                onToggle: (value) {
                  themeProvider.changeDarkTheme(value);
                },
                initialValue: themeProvider.isDark,
                enabled: !themeProvider.isSystem,
                leading: const Icon(Icons.sunny),
                title: Text(
                  'Dark Mode',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          SettingsSection(
              title: Text(
                'Account Related',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.key),
                  title: Text(
                    'Change Password',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onPressed: (context) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChangePasswordPage(),
                      ),
                    );
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.delete),
                  title: Text(
                    'Delete Account',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onPressed: (context) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AccountDeletePage(),
                      ),
                    );
                  },
                ),
              ])
        ],
      ),
    );
  }
}
