import 'dart:html';

import 'package:rideshare/models/user.dart' as model;

class Listing {
  model.User user;
  String listingType;
  DateTime time = DateTime.utc(1989, 11, 9);
  int price;
  String departure;
  String destination;
  String description;

  Listing({
    required this.user,
    required this.listingType,
    required this.time,
    required this.price,
    required this.departure,
    required this.destination,
    required this.description,
  });
}
