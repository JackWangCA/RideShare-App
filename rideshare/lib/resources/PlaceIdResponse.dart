import 'dart:convert';

import 'package:rideshare/resources/PlaceIdDetails.dart';

class PlaceIdResponse {
  final String? status;
  final PlaceIdDetails? details;

  PlaceIdResponse({this.status, this.details});

  factory PlaceIdResponse.fronJson(Map<String, dynamic> json) {
    return PlaceIdResponse(
      status: json["status"] as String?,
      // ignore: prefer_null_aware_operators
      details: json["result"] != null
          ? PlaceIdDetails.fromJson(json["result"])
          : null,
    );
  }

  static PlaceIdResponse paresePlaceIdResult(String responseBody) {
    // print(responseBody);
    final parsed = json.decode(responseBody).cast<String, dynamic>();

    return PlaceIdResponse.fronJson(parsed);
  }
}
