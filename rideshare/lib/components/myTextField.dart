import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final TextInputType inputType;
  String? autofillHints;
  int? maxLines;
  int? maxLength;

  MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.inputType,
    this.autofillHints,
    this.maxLines,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    String autofill = "no";
    if (autofillHints != "no" && autofillHints != null) {
      autofill = autofillHints!;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        keyboardType: inputType,
        obscureText: obscureText,
        controller: controller,
        autofillHints: [autofill],
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
