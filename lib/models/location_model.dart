import 'package:cloud_firestore/cloud_firestore.dart';

class LocationModel {
  final String locationId;
  final String name;
  final GeoPoint geopoint;

  const LocationModel({
    required this.locationId,
    required this.name,
    required this.geopoint,
  });

  static LocationModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return LocationModel(
      locationId: snapshot["locationId"],
      name: snapshot["name"],
      geopoint: snapshot["geopoint"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "geopoint": geopoint,
      };
}
