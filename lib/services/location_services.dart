import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/models/match_model.dart';
import 'package:fitxkonnect/models/sport_model.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/services/sport_services.dart';
import 'package:flutter/material.dart';

class LocationServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getLocationSports(String s) async {
    String result = "";
    LocationModel location = LocationModel.fromSnap(
        await _firestore.collection('locations').doc(s).get());

    List locationSports = location.sports;
    for (int i = 0; i < locationSports.length; i++) {
      SportModel sport = SportModel.fromSnap(
          await _firestore.collection('sports').doc(locationSports[i]).get());
      result = result + '${sport.name}, ';
    }

    return result;
  }

  Future<LocationModel> getCertainLocation(String locationId) async {
    LocationModel location = LocationModel.fromSnap(
        await _firestore.collection('locations').doc(locationId).get());

    return location;
  }

  Future<String> getLocationId(String locationName) async {
    var result = await _firestore
        .collection('locations')
        .where('name', isEqualTo: locationName)
        .get();

    LocationModel location = LocationModel.fromSnap(result.docs[0]);
    return location.locationId;
  }

  Future<List<LocationModel>> getListOfLocationsBasedOfSelectedSports(
      List<SportModel> sports) async {
    print("I AM HERE TO FILTER!");
    List<LocationModel> locations =
        await LocationServices().getListOfLocations();
    String sportId = "";
    List<LocationModel> my_locations = [];
    for (var loc in locations) {
      print("V1");
      print("V1 LOCATION : ${loc.name}");
      for (var sport in sports) {
        print("V1.1");
        print("V1.1 SPORT : ${sport.name}");
        sportId = await SportServices().getSportIdBasedOfName(sport.name);
        print("V2");
        print("V2: $sportId");
        if (loc.sports.contains(sportId) && !(my_locations.contains(loc))) {
          print("V3");
          my_locations.add(loc);
          print("V4");
        }
        print("V5");
      }
    }
    print("V6");
    for (var l in my_locations) {
      print("V7");
      print("LOCATION FILTERED: ${l.name}");
    }
    return my_locations;
  }

  Future<List<LocationModel>> getListOfLocationsBasedOfASport(
      String sport) async {
    print("I AM HERE TO FILTER!");
    List<LocationModel> locations =
        await LocationServices().getListOfLocations();
    String sportId = await SportServices().getSportIdBasedOfName(sport);
    List<LocationModel> my_locations = [];
    for (var loc in locations) {
      if (loc.sports.contains(sportId)) {
        my_locations.add(loc);
      }
    }
    // for (var l in my_locations) {
    //   print("V7");
    //   print("LOCATION FILTERED: ${l.name}");
    // }
    return my_locations;
  }

  Future<List<LocationModel>> getListOfLocations() async {
    var ref = await FirebaseFirestore.instance
        .collection('locations')
        .orderBy('name', descending: false)
        .get();
    List<DocumentSnapshot> locationList = ref.docs;
    List<LocationModel> locations = [];

    locationList.forEach((DocumentSnapshot snap) {
      locations.add(LocationModel.fromSnap(snap));
    });

    return locations;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLocations() async {
    return await FirebaseFirestore.instance
        .collection("matches")
        .orderBy('datePublished', descending: true)
        .get();
  }
}
