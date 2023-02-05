import 'package:flutter/material.dart';
import 'package:rideshare/screens/Auth/SignInScreen.dart';

import 'SignUpScreen.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  //initially show sign in page
  bool showSignInPage = true;

  //toggle between sign in and sign up page
  void togglePages() {
    setState(() {
      showSignInPage = !showSignInPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignInPage) {
      return SignInPage(
        onTap: () {
          togglePages();
        },
      );
    } else {
      return SignUpPage(
        onTap: () {
          togglePages();
        },
      );
    }
  }
}
