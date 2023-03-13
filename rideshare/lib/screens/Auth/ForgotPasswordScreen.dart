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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Please enter your email address.",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              MyTextField(
                autofillHints: AutofillHints.username,
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
                inputType: TextInputType.emailAddress,
              ),
              const Spacer(),
              MyButton(
                child: Text(
                  "Send reset link",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).canvasColor, fontSize: 15.0),
                ),
                onTap: () {
                  passwordReset();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
