import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rideshare/models/user.dart' as model;

class Listing {
  String uid;
  String listingType;
  DateTime departTime; //in utc
  DateTime publishedTime; //in utc
  double price;
  GeoPoint startLocation;
  GeoPoint destination;
  String description;

  Listing({
    this.uid = "",
    this.listingType = "Request",
    required this.departTime,
    required this.publishedTime,
    this.price = 0,
    this.startLocation = const GeoPoint(0, 0),
    this.destination = const GeoPoint(0, 0),
    this.description = "",
  });

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "listingType": listingType,
        "departTime": departTime,
        "publishedTime": publishedTime,
        "price": price,
        "startLocation": startLocation,
        "destination": destination,
        "listings": description,
      };
}
