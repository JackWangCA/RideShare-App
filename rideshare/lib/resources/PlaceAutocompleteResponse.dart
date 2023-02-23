import 'dart:convert';

import 'package:rideshare/resources/AutocompletePrediction.dart';

class PlaceAutocompleteResponse {
  final String? status;
  final List<AutoCompletePrediction>? predictions;

  PlaceAutocompleteResponse({this.status, this.predictions});

  factory PlaceAutocompleteResponse.fronJson(Map<String, dynamic> json) {
    return PlaceAutocompleteResponse(
      status: json["status"] as String?,
      // ignore: prefer_null_aware_operators
      predictions: json["predictions"] != null
          ? json["predictions"]
              .map<AutoCompletePrediction>(
                  (json) => AutoCompletePrediction.fromJson(json))
              .toList()
          : null,
    );
  }

  static PlaceAutocompleteResponse pareseAutoCompleteResult(
      String responseBody) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();

    return PlaceAutocompleteResponse.fronJson(parsed);
  }
}
