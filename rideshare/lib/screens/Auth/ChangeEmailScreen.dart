import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../components/myButton.dart';
import '../../components/myTextField.dart';
import '../../resources/AuthService.dart';
import 'ChangeEmailSuccessScreen.dart';

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final emailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
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
          "Change Email Address",
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
                  "Please enter your new email address.",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Note that you will be logged off after changing your email.",
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              MyTextField(
                controller: emailController,
                hintText: 'New Email Address',
                obscureText: false,
                inputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
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
                  String result = await AuthService().updateEmail(
                    newEmail: emailController.text.trim(),
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
                            builder: (context) => ChangeEmailSuccessPage(),
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
