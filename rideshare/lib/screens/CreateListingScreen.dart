import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CreateListingPage extends StatefulWidget {
  const CreateListingPage({super.key});

  @override
  State<CreateListingPage> createState() => _CreateListingPageState();
}

class _CreateListingPageState extends State<CreateListingPage> {
  final descriptionController = TextEditingController();
  DateTime selectedDateTime = DateTime.now().toUtc();
  TimeOfDay selectedTime = TimeOfDay.now();

  void showIosDatePicker(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
              height: 180.0,
              child: CupertinoDatePicker(
                initialDateTime: selectedDateTime.toLocal(),
                minimumDate: DateTime.now()
                    .toLocal()
                    .subtract(const Duration(seconds: 1)),
                onDateTimeChanged: (val) {
                  setState(() {
                    selectedDateTime = val.toUtc();
                  });
                },
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Plan Your Ride',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    showIosDatePicker(context);
                  },
                  child: const Icon(Icons.date_range),
                ),
                Text(selectedDateTime.toString()),
                Text(selectedDateTime.toLocal().toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
