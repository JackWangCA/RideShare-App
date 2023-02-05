import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rideshare/components/myButton.dart';
import 'package:rideshare/components/myTextField.dart';
import 'package:rideshare/components/squareTile.dart';
import 'package:rideshare/resources/AuthService.dart';

import 'ForgotPasswordScreen.dart';
import '../SettingScreen.dart';

class SignInPage extends StatefulWidget {
  final Function()? onTap;

  SignInPage({super.key, required this.onTap});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  //Sign User In
  void signIn() async {
    //do a loading circle
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    //try signinig in
    // try {

    if (emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty) {
      String result = await AuthService().signUserIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (result != "success") {
        //pop the circle
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }

        if (result == 'user-not-found') {
          showMessage("Seems like you haven't signed up yet");
        }
        //Weak-Password
        else if (result == 'wrong-password') {
          showMessage('Wrong Password. Maybe try again?');
        }
        //invalid email
        else if (result == 'invalid-email') {
          showMessage("Hmmm, that email doesn't look right....");
        }
        //email already in use
        else if (result == 'user-disabled') {
          showMessage(
              "Your account has been suspended. Contact support at xxxxxx@gmail.com");
        }
        //other errors
        else {
          showMessage(result);
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } else {
      //pop the circle
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      showMessage("You haven't even entered anything yet!  :(");
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
                      const SizedBox(height: 25),
                      //Welcome Text
                      Text(
                        'Hi there!',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      //Email Field
                      const SizedBox(height: 25),
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
                      //Forgot Password?
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) {
                                return ForgotPasswordPage();
                              }),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Forgot Password?',
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
                      //Sign In Button
                      const SizedBox(height: 20),
                      MyButton(
                        text: "Sign In",
                        onTap: () {
                          signIn();
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
                                'Not a member?',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: Colors.grey),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                'Register Now',
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
