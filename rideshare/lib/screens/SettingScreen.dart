import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        ],
      ),
    );
  }
}
