import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:rideshare/resources/AuthService.dart';

import '../../components/myButton.dart';
import '../../components/myTextField.dart';
import 'ChangePasswordSuccessScreen.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;

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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Change Password",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
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
              const Spacer(),
              MyButton(
                child: isLoading
                    ? const CircularProgressIndicator(
                        strokeWidth: 4.0,
                        color: Colors.grey,
                      )
                    : Text(
                        "Confirm",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).canvasColor,
                            fontSize: 15.0),
                      ),
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  String result = await AuthService().updatePassword(
                    newPassword: passwordController.text.trim(),
                    confirmPassword: confirmPasswordController.text.trim(),
                  );
                  setState(() {
                    isLoading = false;
                  });
                  if (result != "success") {
                    showMessage(result);
                  } else {
                    await AuthService().signOut();
                    // ignore: use_build_context_synchronously
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ChangePasswordSuccessPage(),
                            maintainState: true),
                        (Route<dynamic> route) => false);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
