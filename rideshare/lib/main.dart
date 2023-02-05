import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rideshare/screens/Auth/AuthScreen.dart';
import 'package:rideshare/screens/HomeScreen.dart';
import 'package:rideshare/constants/theme.dart';
import 'package:rideshare/components/themeProvider.dart';
import 'package:rideshare/screens/Auth/SignInScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: provider.themeMode,
          home: AuthPage(),
        );
      },
    );
  }
}
