import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rideshare/home_screen.dart';
import 'package:rideshare/theme.dart';
import 'package:rideshare/themeProvider.dart';

void main() {
  runApp(
    ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider()..initialze(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: provider.themeMode,
          home: const HomeScreen(),
        );
      },
    );
  }
}
