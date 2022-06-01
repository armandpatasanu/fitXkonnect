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

  Future<List<String>> getListOfLocationSports(String loc) async {
    List<String> result = [];
    LocationModel location = LocationModel.fromSnap(
        await _firestore.collection('locations').doc(loc).get());

    List locationSports = location.sports;
    for (int i = 0; i < locationSports.length; i++) {
      SportModel sport = SportModel.fromSnap(
          await _firestore.collection('sports').doc(locationSports[i]).get());

      result.add(sport.name);
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

  Future<List<Map<LocationModel, List<String>>>>
      getListOfLocationsBasedOfSelectedSports(List<SportModel> sports) async {
    bool contains = false;
    List<LocationModel> locations =
        await LocationServices().getListOfLocations();
    sports.forEach((element) {
      print("SELECTED SPORT IS: ${element.name}");
    });
    String sportId = "";
    List<Map<LocationModel, List<String>>> map = await getMapOfLocations();
    List<String> sportz = [];
    List<Map<LocationModel, List<String>>> my_locations = [];
    for (var m in map) {
      print(" VINE LOCATIA: ${m.keys.first.name}");
      m.values.first.forEach((element) {
        print("VINE LOCATIA CU SPORTUL: ${element}");
      });
      for (var sport in sports) {
        print(" VINE SPORTU: ${sport.name}");
        if (m.values.last.contains(sport.name)) {
          print(" VINE INTRU");
          sportz.add(sport.name);
        }
      }
      LocationModel lm = m.keys.first;
      for (m in my_locations) {
        if ((m.containsKey(lm))) {
          contains = true;
        }
      }
      if (contains == false && sportz.length > 0) {
        Map<LocationModel, List<String>> map = {
          lm: sportz,
        };
        my_locations.add(map);
        print("VINE 1");
      }
      sportz = [];
    }

    return my_locations;
  }

  Future<List<Map<LocationModel, List<String>>>> getMapOfLocationsBasedOfASport(
      String sport) async {
    List<LocationModel> locations =
        await LocationServices().getListOfLocations();
    List<String> sportz = [];

    String sportId = await SportServices().getSportIdBasedOfName(sport);

    List<Map<LocationModel, List<String>>> my_locations = [];

    if (sport == "LIST") {
      my_locations = await getMapOfLocations();
    } else {
      for (var loc in locations) {
        if (loc.sports.contains(sportId)) {
          for (var sp in loc.sports) {
            sp = await SportServices().getSportNameBasedOfId(sp);
            sportz.add(sp);
          }
          Map<LocationModel, List<String>> map = {
            loc: sportz,
          };
          sportz = [];
          my_locations.add(map);
        }
      }
    }
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

  Future<List<Map<LocationModel, List<String>>>> getMapOfLocations() async {
    List<Map<LocationModel, List<String>>> myWanted = [];
    List<LocationModel> locations = await getListOfLocations();

    List<String> sports = [];
    String sp = "";

    for (var loc in locations) {
      print("MAPPING THIS LOCATION: ${loc.name}");
      for (var sp in loc.sports) {
        print("MAPPING THIS SPORT FOR ${loc.name} ");
        sp = await SportServices().getSportNameBasedOfId(sp);
        print("ZPORT: $sp");
        sports.add(sp);
      }

      Map<LocationModel, List<String>> map = {
        loc: sports,
      };
      myWanted.add(map);
      sports = [];
    }
    return myWanted;
  }

  void updateDistance(String locationId, String distance) {
    FirebaseFirestore.instance
        .collection('locations')
        .doc(locationId)
        .update({"distance": distance});
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLocations() async {
    return await FirebaseFirestore.instance
        .collection("matches")
        .orderBy('datePublished', descending: true)
        .get();
  }
}
