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
  String startLocationText;
  String destinationText;
  String description;
  String uuid;

  Listing({
    this.uid = "",
    this.listingType = "Request",
    required this.departTime,
    required this.publishedTime,
    this.price = 0,
    this.startLocation = const GeoPoint(0, 0),
    this.destination = const GeoPoint(0, 0),
    this.startLocationText = "",
    this.destinationText = "",
    this.description = "",
    this.uuid = "",
  });

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "listingType": listingType,
        "departTime": departTime,
        "publishedTime": publishedTime,
        "price": price,
        "startLocation": startLocation,
        "destination": destination,
        "startLocationText": startLocationText,
        "destinationText": destinationText,
        "description": description,
        "uuid": uuid,
      };

  static Listing fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Listing(
      uid: snapshot["uid"],
      listingType: snapshot["listingType"],
      departTime: snapshot["departTime"].toDate(),
      publishedTime: snapshot["publishedTime"].toDate(),
      price: snapshot["price"],
      startLocation: snapshot["startLocation"],
      destination: snapshot["destination"],
      startLocationText: snapshot["startLocationText"],
      destinationText: snapshot["destinationText"],
      description: snapshot["description"],
      uuid: snapshot["description"],
    );
  }
}
