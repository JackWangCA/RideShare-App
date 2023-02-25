import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class VerifyEmailSuccessPage extends StatelessWidget {
  const VerifyEmailSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Success",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
