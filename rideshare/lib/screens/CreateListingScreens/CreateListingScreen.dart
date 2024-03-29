import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rideshare/components/myButton.dart';
import 'package:rideshare/models/listing.dart';
import 'package:rideshare/screens/CreateListingScreens/ChooseLocationScreen.dart';
import 'package:uuid/uuid.dart';

class CreateListingPage extends StatefulWidget {
  const CreateListingPage({super.key});

  @override
  State<CreateListingPage> createState() => _CreateListingPageState();
}

class _CreateListingPageState extends State<CreateListingPage> {
  var uuid = Uuid();
  String listingId = "";
  DateTime selectedDateTime = DateTime.now().toUtc();
  final authUser = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    listingId = uuid.v4();
    selectedDateTime = DateTime.now().toUtc();
  }

  DateTime latestTime() {
    if (selectedDateTime.toLocal().isBefore(DateTime.now())) {
      selectedDateTime = DateTime.now();
    }
    return selectedDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Plan Your Ride',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20.0,
              ),
              Text(
                "Set a time for your ride",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(
                height: 180,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  initialDateTime: latestTime(),
                  minimumDate: DateTime.now().toLocal().subtract(
                        const Duration(seconds: 1),
                      ),
                  onDateTimeChanged: (val) {
                    setState(() {
                      if (val.isBefore(DateTime.now())) {
                        val = DateTime.now();
                      }
                      selectedDateTime = val.toUtc();
                    });
                  },
                ),
              ),
              //Testing Purposes
              const SizedBox(
                height: 20.0,
              ),
              Text("Local Time: ${selectedDateTime.toLocal()}"),
              const SizedBox(
                height: 20.0,
              ),
              const Spacer(),
              MyButton(
                onTap: () {
                  selectedDateTime = latestTime();
                  Listing listing = Listing(
                    departTime: selectedDateTime.toUtc(),
                    publishedTime: selectedDateTime.toUtc(),
                  );
                  listing.uid = authUser.uid;
                  listing.uuid = listingId;
                  if (mounted) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChooseLocationPage(
                          listing: listing,
                        ),
                      ),
                    );
                  }
                },
                child: Text(
                  "Choose Locations",
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
