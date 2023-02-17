import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:geolocator/geolocator.dart';

class CreateListingPage extends StatefulWidget {
  const CreateListingPage({super.key});

  @override
  State<CreateListingPage> createState() => _CreateListingPageState();
}

class _CreateListingPageState extends State<CreateListingPage> {
  GeoPoint? userLocation;
  GeoPoint? startLocation;
  GeoPoint? destination;
  final descriptionController = TextEditingController();
  DateTime selectedDateTime = DateTime.now().toUtc();

  @override
  void initState() {
    super.initState();
    selectedDateTime = DateTime.now().toUtc();
    determineLocation();
  }

  void determineLocation() async {
    String result = "Some error occurred, please try again later.";
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      result = "Location Service is disabled";
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        result = "Location Permission is denied.";
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      result = "Location Permission is permanently denied.";
    }
    if ((serviceEnabled && permission == LocationPermission.always) ||
        (serviceEnabled && permission == LocationPermission.whileInUse)) {
      Position userPosition = await Geolocator.getCurrentPosition();
      setState(() {
        userLocation = GeoPoint(userPosition.latitude, userPosition.longitude);
      });

      result = "success";
    }
    if (result != "success") {
      print(result);
    }
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
      appBar: AppBar(
        title: Text(
          'Plan Your Ride',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                  minimumDate: DateTime.now()
                      .toLocal()
                      .subtract(const Duration(seconds: 1)),
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
              Text(userLocation == null
                  ? "No data"
                  : userLocation!.latitude.toString()),
              const SizedBox(
                height: 20.0,
              ),
              Text(userLocation == null
                  ? "No data"
                  : userLocation!.longitude.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
