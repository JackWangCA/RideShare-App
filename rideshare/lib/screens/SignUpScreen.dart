import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rideshare/components/myButton.dart';
import 'package:rideshare/components/myTextField.dart';
import 'package:rideshare/components/squareTile.dart';

import 'SettingScreen.dart';

class SignUpPage extends StatefulWidget {
  final Function()? onTap;

  SignUpPage({super.key, required this.onTap});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //Sign User In
  void signUserUp() async {
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
    //try creating the user
    try {
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        showMessage("The two passwords doesn't match");
      }
      //pop the circle
    } on FirebaseAuthException catch (e) {
      //pop the circle
      Navigator.pop(context);
      //Weak-Password
      if (e.code == 'weak-password') {
        showMessage("Come on! You can come up with a better password!");
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
                  'Nice to meet you!',
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
                    signUserUp();
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
                              .copyWith(color: Theme.of(context).buttonColor),
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
