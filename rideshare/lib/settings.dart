import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:rideshare/themeProvider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('Common', style: Theme.of(context).textTheme.bodySmall),
            tiles: <SettingsTile>[
              SettingsTile.switchTile(
                onToggle: (value) {
                  themeProvider.changeSystemTheme(value);
                },
                initialValue: themeProvider.isSystem,
                leading: Icon(Icons.format_paint),
                title: Text('Follow System Theme'),
              ),
              SettingsTile.switchTile(
                onToggle: (value) {
                  themeProvider.changeDarkTheme(value);
                },
                initialValue: themeProvider.isDark,
                enabled: !themeProvider.isSystem,
                leading: Icon(Icons.sunny),
                title: Text('Dark Mode'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
