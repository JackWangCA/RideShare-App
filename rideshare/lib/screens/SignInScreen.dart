import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rideshare/components/myButton.dart';
import 'package:rideshare/components/myTextField.dart';
import 'package:rideshare/components/squareTile.dart';

import 'SettingScreen.dart';

class SignInPage extends StatefulWidget {
  SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  //Sign User In
  void signUserIn() async {
    //do a loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
            ),
          );
        });
    //try signinig in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      //pop the circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop the circle
      Navigator.pop(context);
      //Wrong Email or did not register
      if (e.code == 'user-not-found') {
        showMessage("Seems like you haven't signed up yet");
      }
      //Wrong Password
      else if (e.code == 'wrong-password') {
        showMessage('Wrong Password. Maybe try again?');
      }
      //invalid email
      else if (e.code == 'invalid-email') {
        showMessage("Hmmm, that email doesn't look right....");
      }
      //other errors
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                //logo
                const Icon(
                  Icons.car_rental,
                  size: 100,
                ),
                const SizedBox(height: 50),
                //Welcome Text
                Text(
                  'Welcome Back!',
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                //Sign In Button
                const SizedBox(height: 20),
                MyButton(
                  onTap: () {
                    signUserIn();
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
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
                              .copyWith(color: Colors.grey),
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
