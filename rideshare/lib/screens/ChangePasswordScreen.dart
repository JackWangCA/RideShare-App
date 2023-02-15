import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:rideshare/resources/AuthService.dart';

import '../components/myButton.dart';
import '../components/myTextField.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
          "Change Password",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),

                  Container(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Please enter your new password.",
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
                  const SizedBox(height: 25.0),
                  MyButton(
                    text: "Confirm",
                    onTap: () async {
                      String result = await AuthService().updatePassword(
                        newPassword: passwordController.text.trim(),
                        confirmPassword: confirmPasswordController.text.trim(),
                      );
                      if (result != "success") {
                        showMessage(result);
                      } else {
                        showMessage("Password changed successfully");
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
