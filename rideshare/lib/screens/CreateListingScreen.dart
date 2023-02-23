import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rideshare/models/LocationListTile.dart';
import 'package:rideshare/resources/AutocompletePrediction.dart';
import 'package:rideshare/resources/NetworkService.dart';

import '../resources/PlaceAutoCompleteResponse.dart';

class CreateListingPage extends StatefulWidget {
  const CreateListingPage({super.key});

  @override
  State<CreateListingPage> createState() => _CreateListingPageState();
}

class _CreateListingPageState extends State<CreateListingPage> {
  GeoPoint? userLocation;
  GeoPoint? startLocation;
  GeoPoint? destination;
  bool startLocationPredictionOpen = true;
  final descriptionController = TextEditingController();
  final startLocationTextController = TextEditingController();
  DateTime selectedDateTime = DateTime.now().toUtc();
  String apiKey = "AIzaSyAoY0zvH1IO2Q9dB7WbHti7_F_l7fqc7tI";
  String destinationText = "";
  List<AutoCompletePrediction> placePredictions = [];

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

  void placeAutoComplete(String query) async {
    if (query.isNotEmpty) {
      Uri uri = Uri.https(
        "maps.googleapis.com",
        "maps/api/place/autocomplete/json",
        {
          "input": query,
          "key": apiKey,
        },
      );
      String? response = await NetworkService.fetchUrl(uri);

      if (response != null) {
        PlaceAutocompleteResponse result =
            PlaceAutocompleteResponse.pareseAutoCompleteResult(response);

        if (result.predictions != null) {
          setState(() {
            placePredictions = result.predictions!;
          });
        }
      }
    } else {
      setState(() {
        placePredictions = [];
      });
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
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
              Form(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: startLocationTextController,
                    onChanged: (value) {
                      placeAutoComplete(value);
                      setState(() {
                        startLocationPredictionOpen = true;
                      });
                    },
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                      hintText: "Search for your starting location.",
                      prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.0),
                        child: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                height: 4,
                thickness: 4,
                color: Theme.of(context).hintColor,
              ),
              startLocationPredictionOpen
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: placePredictions.length,
                        itemBuilder: (context, index) => LocationListTile(
                          location:
                              placePredictions.elementAt(index).description!,
                          onTap: () {
                            setState(() {
                              startLocationTextController.text =
                                  placePredictions
                                      .elementAt(index)
                                      .description!;
                              startLocationPredictionOpen = false;
                            });
                          },
                        ),
                      ),
                    )
                  : Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
