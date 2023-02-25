import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rideshare/screens/Auth/VerifyEmailScreen.dart';
import 'package:rideshare/screens/HomeScreen.dart';
import 'package:rideshare/screens/Auth/SignInScreen.dart';
import 'package:rideshare/screens/Auth/WelcomeScreen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user is logged in
          if (snapshot.hasData) {
            return HomePage();
          }

          //user is not logged in
          else {
            return const WelcomePage();
          }
        },
      ),
    );
  }
}
