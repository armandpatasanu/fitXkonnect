import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationModel {
  final String locationId;
  final String schedule;
  final String name;
  final GeoPoint geopoint;
  final List contact;
  final List sports;

  const LocationModel({
    required this.locationId,
    required this.contact,
    required this.schedule,
    required this.sports,
    required this.name,
    required this.geopoint,
  });

  static LocationModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return LocationModel(
      schedule: snapshot["schedule"],
      contact: snapshot["contact"],
      sports: snapshot["sports"],
      locationId: snapshot["locationId"],
      name: snapshot["name"],
      geopoint: snapshot["geopoint"],
    );
  }

  Map<String, dynamic> toJson() => {
        "locationId": locationId,
        "schedule": schedule,
        "sports": sports,
        "contact": contact,
        "name": name,
        "geopoint": geopoint,
      };
}
