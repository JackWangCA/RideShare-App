import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rideshare/components/myButton.dart';
import 'package:rideshare/components/myTextField.dart';
import 'package:rideshare/components/squareTile.dart';
import 'package:rideshare/resources/AuthService.dart';

import '../SettingScreen.dart';

class SignUpPage extends StatefulWidget {
  final Function()? onTap;

  SignUpPage({super.key, required this.onTap});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  //Sign User In
  void signUp() async {
    //do a loading circle
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    //try creating the user

    String result = await AuthService().signUserUp(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
    );
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }

    if (result != "success") {
      showMessage(result);
    }
  }

  Future addUserDetails(String firstName, String lastName, String email) async {
    await FirebaseFirestore.instance.collection('users').add({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    });
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
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
            ),
          )
        : Scaffold(
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),

                      //logo
                      Theme.of(context).brightness == Brightness.light
                          ? Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(60, 10, 60, 40),
                              child: Image.asset(
                                  'lib/images/logo/getaway_black.png'),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(60, 10, 60, 40),
                              child: Image.asset(
                                  'lib/images/logo/getaway_white.png'),
                            ),

                      //Welcome Text
                      Text(
                        'Nice to meet you!',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),

                      //First Name Field
                      const SizedBox(height: 25),
                      MyTextField(
                        controller: firstNameController,
                        hintText: 'First Name',
                        obscureText: false,
                        inputType: TextInputType.name,
                      ),

                      //Last Name Field
                      const SizedBox(height: 10),
                      MyTextField(
                        controller: lastNameController,
                        hintText: 'Last Name',
                        obscureText: false,
                        inputType: TextInputType.name,
                      ),

                      //Email Field
                      const SizedBox(height: 10),
                      MyTextField(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                        inputType: TextInputType.emailAddress,
                      ),

                      //Password Field
                      const SizedBox(height: 10),
                      MyTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: true,
                        inputType: TextInputType.text,
                      ),
                      const SizedBox(height: 10),

                      //Confirm Password Field
                      MyTextField(
                        controller: confirmPasswordController,
                        hintText: 'Confirm Password',
                        obscureText: true,
                        inputType: TextInputType.text,
                      ),
                      const SizedBox(height: 10),

                      //Sign Up Button
                      const SizedBox(height: 20),
                      MyButton(
                        text: "Sign Up",
                        onTap: () {
                          signUp();
                        },
                      ),
                      const SizedBox(height: 45),
                      //Divider

                      //Uncomment after ready for google and apple auth

                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      //   child: Row(
                      //     children: [
                      //       Expanded(
                      //         child: Divider(
                      //           thickness: 0.5,
                      //           color: Theme.of(context).dividerColor,
                      //         ),
                      //       ),
                      //       Text(
                      //         'Or Continue With',
                      //         style: Theme.of(context)
                      //             .textTheme
                      //             .bodyMedium!
                      //             .copyWith(color: Theme.of(context).dividerColor),
                      //       ),
                      //       Expanded(
                      //         child: Divider(
                      //           thickness: 0.5,
                      //           color: Theme.of(context).dividerColor,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // const SizedBox(height: 45),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: const [
                      //     SquareTile(imagePath: 'lib/images/google.png'),
                      //     SizedBox(
                      //       width: 30,
                      //     ),
                      //     SquareTile(imagePath: 'lib/images/apple.png'),
                      //   ],
                      // ),
                      // const SizedBox(height: 45),

                      //To go to the sign in screen
                      GestureDetector(
                        onTap: () {
                          widget.onTap!();
                        },
                        child: Container(
                          padding: EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account?',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: Colors.grey),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                'Sign in here',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context).buttonColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
