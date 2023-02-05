import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../components/myButton.dart';
import '../../components/myTextField.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    //try to end password reset link
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      showMessage("Email sent! Check your inbox!");
    } on FirebaseAuthException catch (e) {
      //missing email
      if (e.code == "missing-email") {
        showMessage("You have't entered an email yet!");
      }
      //email format incorrect
      else if (e.code == "invalid-email") {
        showMessage("The formatting doesn't seem right");
      }
      //user does not exist in database
      else if (e.code == "user-not-found") {
        showMessage("You haven't signed up yet");
      }
      //all other situations
      else {
        showMessage(e.code);
      }
    }
  }

  void showMessage(String title) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Forgot Password',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text(
              "Enter your email below",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          MyTextField(
            controller: emailController,
            hintText: 'Email',
            obscureText: false,
            inputType: TextInputType.emailAddress,
          ),
          const SizedBox(
            height: 30.0,
          ),
          MyButton(
            text: "Send reset link",
            onTap: () {
              passwordReset();
            },
          ),
        ],
      ),
    );
  }
}
