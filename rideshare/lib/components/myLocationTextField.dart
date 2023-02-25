import 'package:flutter/material.dart';

class MyLocationTextField extends StatelessWidget {
  final Function(String) onChanged;
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType inputType;

  const MyLocationTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.inputType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextField(
        showCursor: true,
        cursorColor: Theme.of(context).dividerColor,
        onChanged: onChanged,
        keyboardType: inputType,
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            splashRadius: 5.0,
            onPressed: () {
              onChanged('');
              controller.clear();
            },
            icon: Icon(
              Icons.clear,
              color: Theme.of(context).dividerColor,
            ),
          ),
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
