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
    required this.uid,
    required this.listingType,
    required this.departTime,
    required this.publishedTime,
    required this.price,
    required this.startLocation,
    required this.destination,
    required this.description,
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
