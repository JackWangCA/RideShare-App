import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rideshare/components/locationPredictions.dart';
import 'package:rideshare/components/myLocationTextField.dart';
import 'package:rideshare/models/listing.dart';

import '../../models/LocationListTile.dart';
import '../../resources/AutocompletePrediction.dart';
import '../../resources/NetworkService.dart';
import '../../resources/PlaceAutoCompleteResponse.dart';

class ChooseLocationPage extends StatefulWidget {
  final Listing listing;
  const ChooseLocationPage({super.key, required this.listing});

  @override
  State<ChooseLocationPage> createState() => _ChooseLocationPageState();
}

class _ChooseLocationPageState extends State<ChooseLocationPage> {
  @override
  void initState() {
    super.initState();
    determineLocation();
  }

  GeoPoint? userLocation;
  GeoPoint? startLocation;
  GeoPoint? destination;
  final startLocationTextController = TextEditingController();
  final destinationTextController = TextEditingController();
  String apiKey = "AIzaSyAoY0zvH1IO2Q9dB7WbHti7_F_l7fqc7tI";
  String destinationText = "";
  List<AutoCompletePrediction> placePredictions = [];
  bool startLocationPredictionOpen = false;

  Timer? debounce;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pick the places',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Form(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: MyLocationTextField(
                      controller: startLocationTextController,
                      hintText: "Start Location",
                      obscureText: false,
                      inputType: TextInputType.streetAddress,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            startLocationPredictionOpen = false;
                          });
                        }
                        if (debounce?.isActive ?? false) {
                          debounce!.cancel();
                        }
                        debounce =
                            Timer(const Duration(milliseconds: 1000), () {
                          if (value.isEmpty) {
                            setState(() {
                              startLocationPredictionOpen = false;
                            });
                          } else {
                            placeAutoComplete(value);
                            setState(() {
                              startLocationPredictionOpen = true;
                            });
                          }
                        });
                      }),
                ),
              ),
              startLocationPredictionOpen
                  ? Flexible(
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
                  : const SizedBox(),
              Text(widget.listing.departTime.toLocal().toString()),
            ],
          ),
        ),
      ),
    );
  }
}
