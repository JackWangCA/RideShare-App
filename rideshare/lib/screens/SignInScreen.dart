import 'package:flutter/material.dart';
import 'package:rideshare/components/myButton.dart';
import 'package:rideshare/components/myTextField.dart';
import 'package:rideshare/components/squareTile.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  //Sign User In
  void SignUserIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
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
              //Username Field
              const SizedBox(height: 25),
              MyTextField(
                controller: usernameController,
                hintText: 'Username',
                obscureText: false,
              ),
              //Password Field
              const SizedBox(height: 10),
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
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
                  SignUserIn();
                },
              ),
              const SizedBox(height: 45),
              //Divider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    Text(
                      'Or Continue With',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Theme.of(context).dividerColor),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 45),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SquareTile(imagePath: 'lib/images/google.png'),
                  SizedBox(
                    width: 30,
                  ),
                  SquareTile(imagePath: 'lib/images/apple.png'),
                ],
              ),
              const SizedBox(height: 45),
              Row(
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
            ],
          ),
        ),
      ),
    );
  }
}
