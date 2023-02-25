import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:rideshare/screens/HomeScreen.dart';

import '../../components/myButton.dart';
import '../../resources/AuthService.dart';
import 'VerifyEmailSuccessScreen.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = true;
  bool dialogOpen = false;
  Timer? timer;
  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (mounted) {
      if (!isEmailVerified) {
        sendVerificationEmail();
        timer = Timer.periodic(
          const Duration(seconds: 3),
          (_) => checkEmailVerified(),
        );
      }
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      if (mounted) {
        setState(() {
          canResendEmail = false;
        });
      }

      await Future.delayed(const Duration(seconds: 10));
      if (mounted) {
        setState(() {
          canResendEmail = true;
        });
      }
    } catch (e) {
      if (dialogOpen) {
        Navigator.pop(context);
        if (mounted) {
          setState(() {
            dialogOpen = false;
          });
        }
      }
      if (e.toString() ==
          "[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.") {
        showMessage(
            "You can't request more verification code at the moment, try again later");
      } else if (e.toString() ==
          "[firebase_auth/network-request-failed] Network error (such as timeout, interrupted connection or unreachable host) has occurred.") {
        showMessage("No internet connection, please try again later.");
      } else {
        showMessage(e.toString());
      }
    }
  }

  Future reSendVerificationEmail() async {
    showMessage("A email resend request has been made");
    sendVerificationEmail();
  }

  Future checkEmailVerified() async {
    try {
      await FirebaseAuth.instance.currentUser!.reload();
    } catch (e) {}

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void showMessage(String title) {
    if (mounted) {
      setState(() {
        dialogOpen = true;
      });
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            contentPadding: const EdgeInsets.all(10.0),
            title: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? VerifyEmailSuccessPage()
        : Scaffold(
            appBar: AppBar(
              title: const Text("Verify Email"),
              actions: [
                IconButton(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.currentUser!.reload();
                    } catch (e) {
                      if (e.toString() ==
                          "[firebase_auth/network-request-failed] Network error (such as timeout, interrupted connection or unreachable host) has occurred.") {
                        showMessage(
                            "No internet connection, please try again later.");
                      }
                    }
                    String result = await AuthService().deleteUser();
                    if (result == "success") {
                      AuthService().signOut();
                    } else {
                      showMessage(result);
                    }
                  },
                  icon: const Icon(Icons.logout),
                )
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Text(
                      "An email has been sent to your inbox, please click on the link to verify",
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    MyButton(
                      child: Text(
                        "Resend Email",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).canvasColor,
                            fontSize: 15.0),
                      ),
                      onTap: () {
                        canResendEmail
                            ? reSendVerificationEmail()
                            : showMessage("You have already resent a email!");
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
