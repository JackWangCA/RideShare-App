import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final Widget child;

  const MyButton({super.key, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: SizedBox(
        width: double.infinity,
        height: 70,
        child: ElevatedButton(
            onPressed: () {
              onTap!();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0), // <-- Radius
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: child,
            )),
      ),
    );
  }
}
