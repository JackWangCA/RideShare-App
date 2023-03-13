import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final TextInputType inputType;
  final String autofillHints;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.inputType,
    this.autofillHints = "no",
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        keyboardType: inputType,
        obscureText: obscureText,
        controller: controller,
        autofillHints: [autofillHints],
        decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Theme.of(context).dividerColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Theme.of(context).focusColor),
          ),
          fillColor: Theme.of(context).dialogBackgroundColor,
          filled: true,
        ),
      ),
    );
  }
}
