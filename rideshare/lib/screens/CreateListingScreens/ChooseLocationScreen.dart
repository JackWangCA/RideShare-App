import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideshare/components/locationPredictions.dart';
import 'package:rideshare/components/myLocationTextField.dart';
import 'package:rideshare/models/listing.dart';
import 'package:rideshare/resources/PlaceIdDetails.dart';

import '../../components/myButton.dart';
import '../../models/LocationListTile.dart';
import '../../resources/AutocompletePrediction.dart';
import '../../resources/NetworkService.dart';
import '../../resources/PlaceAutoCompleteResponse.dart';
import '../../resources/PlaceIdResponse.dart';
import 'FinalizeDetailsScreen.dart';

class ChooseLocationPage extends StatefulWidget {
  final Listing listing;
  const ChooseLocationPage({super.key, required this.listing});

  @override
  State<ChooseLocationPage> createState() => _ChooseLocationPageState();
}

class _ChooseLocationPageState extends State<ChooseLocationPage> {
  String apiKey = "AIzaSyAoY0zvH1IO2Q9dB7WbHti7_F_l7fqc7tI";
  late Listing listing;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  GeoPoint? userLocation = const GeoPoint(40.1020, -88.2272);
  GeoPoint? startLocation = const GeoPoint(0, 0);
  GeoPoint? destination = const GeoPoint(0, 0);
  Marker startMarker = const Marker(markerId: MarkerId("startLocation"));
  Marker destinationMarker = const Marker(markerId: MarkerId("destination"));
  String startLocationPlaceId = "";
  String destinationPlaceId = "";
  GoogleMap? map;
  GoogleMapController? mapController;
  // late BitmapDescriptor startIcon;
  // late BitmapDescriptor endIcon;

  final startLocationTextController = TextEditingController();
  final destinationTextController = TextEditingController();

  late FocusNode startLocationFocusNode;
  late FocusNode destinationFocusNode;

  List<AutoCompletePrediction> startLocationPredictions = [];
  List<AutoCompletePrediction> destinationPredictions = [];
  bool locationPredictionOpen = false;

  Timer? debounce;
  @override
  void initState() {
    super.initState();
    listing = widget.listing;
    determineLocation();
    startLocationFocusNode = FocusNode();
    destinationFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    startLocationFocusNode.dispose();
    destinationFocusNode.dispose();
    startLocationTextController.dispose();
    destinationTextController.dispose();
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
      animateCamera();

      result = "success";
    }
    if (result != "success") {
      print(result);
    }
  }

  void showMessage(String title) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          contentPadding: const EdgeInsets.all(10.0),
          title: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      },
    );
  }

  //Get coordinates from placeid
  Future<PlaceIdDetails> getDetailsFromPlaceId(String placeId) async {
    PlaceIdDetails details = PlaceIdDetails(
      name: "",
      geometry: Geometry(
        location: Location(lat: 0, lng: 0),
      ),
    );
    Uri geocoderuri = Uri.https(
      "maps.googleapis.com",
      "maps/api/place/details/json",
      {
        "place_id": placeId,
        "key": apiKey,
      },
    );
    String? response = await NetworkService.fetchUrl(geocoderuri);
    if (response != null) {
      PlaceIdResponse result = PlaceIdResponse.paresePlaceIdResult(response);
      if ((result.details != null)) {
        details.name = result.details!.name;
        details.geometry = result.details!.geometry;
      }
    }
    return details;
  }

  Future<List<AutoCompletePrediction>> placeAutoComplete(String query) async {
    List<AutoCompletePrediction> predictions = [];
    if (query.isNotEmpty) {
      Uri autoCompleteuri = Uri.https(
        "maps.googleapis.com",
        "maps/api/place/autocomplete/json",
        {
          "input": query,
          "key": apiKey,
        },
      );
      String? response = await NetworkService.fetchUrl(autoCompleteuri);

      if (response != null) {
        PlaceAutocompleteResponse result =
            PlaceAutocompleteResponse.pareseAutoCompleteResult(response);
        if (result.predictions != null) {
          predictions = result.predictions!;
        }
      }
    } else {
      predictions = [];
    }
    return predictions;
  }

  void animateCamera() {
    if (markers.isEmpty) {
      mapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(userLocation!.latitude, userLocation!.longitude),
              zoom: 13)));
    } else if (markers.length == 1) {
      if (markers.containsKey(const MarkerId("start"))) {
        mapController?.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(
                    markers[const MarkerId("start")]!.position.latitude,
                    markers[const MarkerId("start")]!.position.longitude),
                zoom: 13)));
      } else if (markers.containsKey(const MarkerId("end"))) {
        mapController?.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(
                    markers[const MarkerId("end")]!.position.latitude,
                    markers[const MarkerId("end")]!.position.longitude),
                zoom: 13)));
      }
    } else if (markers.length == 2) {
      double lat = (markers[const MarkerId("start")]!.position.latitude +
              markers[const MarkerId("end")]!.position.latitude) /
          2.0;
      double lng = (markers[const MarkerId("start")]!.position.longitude +
              markers[const MarkerId("end")]!.position.longitude) /
          2.0;
      LatLng middle = LatLng(lat, lng);
      double distanceInKM = Geolocator.distanceBetween(
              markers[const MarkerId("start")]!.position.latitude,
              markers[const MarkerId("start")]!.position.longitude,
              markers[const MarkerId("end")]!.position.latitude,
              markers[const MarkerId("end")]!.position.longitude) /
          1000;
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(middle.latitude, middle.longitude),
            zoom: 16 - log(distanceInKM * 1.6) / log(2),
          ),
        ),
      );
    }
  }

// Will set the location, location text, maker details, and camera based on focus
  void setLocation(GeoPoint location, PlaceIdDetails locationDetails) {
    setState(() {
      if (startLocationFocusNode.hasFocus) {
        startLocation = location;
        startLocationTextController.text = locationDetails.name!;
        String locationName = locationDetails.name!;
        startMarker = Marker(
          markerId: const MarkerId("start"),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(title: locationName),
        );
        setState(() {
          markers[startMarker.markerId] = startMarker;
        });
      } else {
        destination = location;
        destinationTextController.text = locationDetails.name!;
        String locationName = locationDetails.name!;
        destinationMarker = Marker(
          markerId: const MarkerId("end"),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(title: locationName),
        );
        setState(() {
          markers[destinationMarker.markerId] = destinationMarker;
        });
      }
      locationPredictionOpen = false;
      animateCamera();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Pick the places',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
              onPressed: () {
                showMessage(
                    "If you can't find your desired location through the autocomplete system, you can simply press confirm after entering the address. Please note that by doing this, your listing will no longer display a map showing the start and destination.");
              },
              icon: const Icon(Icons.help))
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 1,
                    //Maps Widget
                    child: GoogleMap(
                      onMapCreated: (controller) {
                        //method called when map is created
                        setState(
                          () {
                            mapController = controller;
                          },
                        );
                        animateCamera();
                      },
                      myLocationEnabled: true,
                      scrollGesturesEnabled: true,
                      myLocationButtonEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                            userLocation!.latitude, userLocation!.longitude),
                      ),
                      markers: Set<Marker>.of(markers.values),
                    ),
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Focus(
                        onFocusChange: (value) {
                          if (!startLocationFocusNode.hasFocus) {
                            setState(() {
                              locationPredictionOpen = false;
                            });
                          }
                        },
                        child: MyLocationTextField(
                            focusNode: startLocationFocusNode,
                            controller: startLocationTextController,
                            hintText: "Start",
                            obscureText: false,
                            inputType: TextInputType.streetAddress,
                            onChanged: (value) {
                              startLocation = const GeoPoint(0, 0);
                              if (value.isEmpty) {
                                setState(
                                  () {
                                    locationPredictionOpen = false;
                                    startLocation = const GeoPoint(0, 0);
                                    if (markers
                                        .containsKey(const MarkerId("start"))) {
                                      markers.remove(const MarkerId("start"));
                                    }
                                  },
                                );
                                animateCamera();
                              }
                              if (debounce?.isActive ?? false) {
                                debounce!.cancel();
                              }
                              //Only send request after user finishes typing, saves some money
                              debounce = Timer(
                                  const Duration(milliseconds: 1000), () async {
                                if (value.isEmpty) {
                                  setState(() {
                                    locationPredictionOpen = false;
                                  });
                                } else {
                                  List<AutoCompletePrediction>
                                      placePredictions =
                                      await placeAutoComplete(value);
                                  setState(() {
                                    startLocationPredictions = placePredictions;
                                    locationPredictionOpen = true;
                                  });
                                }
                              });
                            }),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    locationPredictionOpen && startLocationFocusNode.hasFocus
                        ? Flexible(
                            fit: FlexFit.loose,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).canvasColor,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: startLocationFocusNode.hasFocus
                                      ? startLocationPredictions.length
                                      : destinationPredictions.length,
                                  itemBuilder: (context, index) =>
                                      LocationListTile(
                                    location: startLocationFocusNode.hasFocus
                                        ? startLocationPredictions
                                            .elementAt(index)
                                            .description!
                                        : destinationPredictions
                                            .elementAt(index)
                                            .description!,
                                    onTap: () async {
                                      setState(() {
                                        if (startLocationFocusNode.hasFocus) {
                                          startLocationPlaceId =
                                              startLocationPredictions
                                                  .elementAt(index)
                                                  .placeId!;
                                        } else {
                                          destinationPlaceId =
                                              destinationPredictions
                                                  .elementAt(index)
                                                  .placeId!;
                                        }
                                      });
                                      PlaceIdDetails locationDetails =
                                          startLocationFocusNode.hasFocus
                                              ? await getDetailsFromPlaceId(
                                                  startLocationPlaceId)
                                              : await getDetailsFromPlaceId(
                                                  destinationPlaceId);
                                      GeoPoint location = GeoPoint(
                                          locationDetails
                                              .geometry!.location!.lat!,
                                          locationDetails
                                              .geometry!.location!.lng!);
                                      setLocation(location, locationDetails);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Focus(
                              onFocusChange: (value) {
                                if (!destinationFocusNode.hasFocus) {
                                  setState(() {
                                    locationPredictionOpen = false;
                                  });
                                }
                              },
                              child: MyLocationTextField(
                                  focusNode: destinationFocusNode,
                                  controller: destinationTextController,
                                  hintText: "End",
                                  obscureText: false,
                                  inputType: TextInputType.streetAddress,
                                  onChanged: (value) {
                                    destination = const GeoPoint(0, 0);
                                    if (value.isEmpty) {
                                      setState(
                                        () {
                                          locationPredictionOpen = false;
                                          destination = const GeoPoint(0, 0);
                                          if (markers.containsKey(
                                              const MarkerId("end"))) {
                                            markers
                                                .remove(const MarkerId("end"));
                                          }
                                        },
                                      );
                                      animateCamera();
                                    }
                                    if (debounce?.isActive ?? false) {
                                      debounce!.cancel();
                                    }
                                    //Only send request after user finishes typing, saves some money
                                    debounce = Timer(
                                        const Duration(milliseconds: 1000),
                                        () async {
                                      if (value.isEmpty) {
                                        setState(() {
                                          locationPredictionOpen = false;
                                        });
                                      } else {
                                        List<AutoCompletePrediction>
                                            placePredictions =
                                            await placeAutoComplete(value);
                                        setState(
                                          () {
                                            destinationPredictions =
                                                placePredictions;
                                            locationPredictionOpen = true;
                                          },
                                        );
                                      }
                                    });
                                  }),
                            ),
                          ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    locationPredictionOpen && destinationFocusNode.hasFocus
                        ? Flexible(
                            fit: FlexFit.loose,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).canvasColor,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: startLocationFocusNode.hasFocus
                                      ? startLocationPredictions.length
                                      : destinationPredictions.length,
                                  itemBuilder: (context, index) =>
                                      LocationListTile(
                                    location: startLocationFocusNode.hasFocus
                                        ? startLocationPredictions
                                            .elementAt(index)
                                            .description!
                                        : destinationPredictions
                                            .elementAt(index)
                                            .description!,
                                    onTap: () async {
                                      setState(() {
                                        if (startLocationFocusNode.hasFocus) {
                                          startLocationPlaceId =
                                              startLocationPredictions
                                                  .elementAt(index)
                                                  .placeId!;
                                        } else {
                                          destinationPlaceId =
                                              destinationPredictions
                                                  .elementAt(index)
                                                  .placeId!;
                                        }
                                      });
                                      PlaceIdDetails locationDetails =
                                          startLocationFocusNode.hasFocus
                                              ? await getDetailsFromPlaceId(
                                                  startLocationPlaceId)
                                              : await getDetailsFromPlaceId(
                                                  destinationPlaceId);
                                      GeoPoint location = GeoPoint(
                                          locationDetails
                                              .geometry!.location!.lat!,
                                          locationDetails
                                              .geometry!.location!.lng!);
                                      setLocation(location, locationDetails);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: MyButton(
                        child: Text(
                          "Confirm Locations",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: Theme.of(context).canvasColor,
                                  fontSize: 15.0),
                        ),
                        onTap: () {
                          // if ((startLocation!.latitude == 0 &&
                          //         startLocation!.longitude == 0) ||
                          //     (destination!.latitude == 0 &&
                          //         destination!.longitude == 0)) {
                          //   showMessage("Please select your start location");
                          // }
                          if (startLocationTextController.text.trim().isEmpty ||
                              destinationTextController.text.trim().isEmpty) {
                            showMessage(
                                "Please enter both your start location and destination");
                          } else {
                            listing.startLocation = GeoPoint(
                                startLocation!.latitude,
                                startLocation!.latitude);
                            listing.destination = GeoPoint(
                                destination!.latitude, destination!.longitude);
                            listing.startLocationText =
                                startLocationTextController.text.trim();
                            listing.destinationText =
                                destinationTextController.text.trim();

                            // print(listing.startLocation.latitude);
                            // print(listing.startLocation.longitude);
                            // print(listing.destination.latitude);
                            // print(listing.destination.longitude);
                            // print(listing.startLocationText);
                            // print(listing.destinationText);
                            // print(listing.departTime.toLocal());
                            if (mounted) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => FinalizeDetailsPage(
                                    listing: listing,
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
