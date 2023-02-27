import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:rideshare/components/myButton.dart';
import 'package:rideshare/resources/AuthService.dart';
import 'package:rideshare/screens/Auth/AuthScreen.dart';

class AccountDeletePage extends StatelessWidget {
  const AccountDeletePage({super.key});

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Delete Account",
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
                  "Are you sure you want to delete your account?",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                    "Any information in your account will be delete forever and can not be recovered in any way possible.",
                    style: Theme.of(context).textTheme.titleMedium!),
              ),
              const Spacer(),
              MyButton(
                onTap: () async {
                  String result = await AuthService().deleteUser();
                  if (result == "success") {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AuthPage(),
                      ),
                    );
                  } else {
                    showMessage(result);
                  }
                },
                child: Text(
                  "Yes. I want to DELETE my account.",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).canvasColor, fontSize: 15.0),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              MyButton(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "No. I want to KEEP my account.",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).canvasColor, fontSize: 15.0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
