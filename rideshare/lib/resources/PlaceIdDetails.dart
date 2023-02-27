class PlaceIdDetails {
  final String? name;

  final Geometry? geometry;

  // final String? placeId;

  PlaceIdDetails({
    this.name,
    this.geometry,
    // this.placeId,
  });

  factory PlaceIdDetails.fromJson(Map<String, dynamic> json) {
    return PlaceIdDetails(
      name: json["name"] as String?,
      geometry:
          json["geometry"] != null ? Geometry.fromJson(json["geometry"]) : null,
    );
  }
}

class Geometry {
  final Location? location;
  // final Viewport? viewport;

  Geometry({this.location});

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      location:
          json["location"] != null ? Location.fromJson(json["location"]) : null,
    );
  }
}

class Location {
  final double? lat;
  final double? lng;

  Location({this.lat, this.lng});
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json["lat"] as double?,
      lng: json["lng"] as double?,
    );
  }
}
