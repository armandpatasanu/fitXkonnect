import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/models/match_model.dart';
import 'package:fitxkonnect/models/sport_model.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/services/sport_services.dart';
import 'package:flutter/material.dart';

class LocationServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<LocationModel>> getLocationsWhereSportIsPlayed(
      String sportName) async {
    List<LocationModel> wanted = [];
    SportModel sport =
        await SportServices().getSpecificSportFromName(sportName);
    List locationIds = sport.playedAt;

    for (var loc in locationIds) {
      wanted.add(await LocationServices().getCertainLocation(loc));
    }
    print("DID IT? ${wanted.length}");
    return wanted;
  }

  Future<String> getLocationSports(String s) async {
    print("Let me try:");
    String result = "";
    LocationModel location = LocationModel.fromSnap(
        await _firestore.collection('locations').doc(s).get());

    List locationSports = location.sports;
    if (locationSports.length == 0) {
      result = "No sport are being played here at the moment!";
    }
    for (int i = 0; i < locationSports.length; i++) {
      SportModel sport = SportModel.fromSnap(await _firestore
          .collection('sports')
          .doc(locationSports[i]["sport"])
          .get());
      locationSports.forEach((element) {
        if (element["sport"] == sport.sportId && element["matches"] > 0) {
          result = result + '${sport.name}, ';
        }
      });
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

    String sportId = "";
    List<Map<LocationModel, List<String>>> map = await getMapOfLocations();
    List<String> sportz = [];
    List<Map<LocationModel, List<String>>> my_locations = [];
    for (var m in map) {
      m.values.first.forEach((element) {});
      for (var sport in sports) {
        if (m.values.last.contains(sport.name)) {
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
    print("@@@@Am intrat cu $sport");

    String sportId = await SportServices().getSportIdBasedOfName(sport);
    String sp = "";
    List<Map<LocationModel, List<String>>> my_locations = [];
    bool isFound = false;

    if (sport == "LIST") {
      my_locations = await getMapOfLocations();
    } else {
      for (var loc in locations) {
        for (var map in loc.sports) {
          if (map["sport"] == sportId && map["matches"] > 0) {
            isFound = true;
          }
        }
        if (isFound == true) {
          for (var sport in loc.sports) {
            if (sport["matches"] > 0) {
              sp = await SportServices().getSportNameBasedOfId(sport["sport"]);
              sportz.add(sp);
            }
          }
          Map<LocationModel, List<String>> map = {
            loc: sportz,
          };
          sportz = [];
          my_locations.add(map);
          isFound = false;
        }
      }
    }
    print("@@@@@Length is ${my_locations.length}");
    return my_locations;
  }

  Future<List<LocationModel>> getListOfLocations() async {
    var ref = await FirebaseFirestore.instance
        .collection('locations')
        .orderBy('name', descending: false)
        .get();
    List<DocumentSnapshot> locationList = ref.docs;
    List<LocationModel> locations = [];
    print("Not blocat!");
    locationList.forEach((DocumentSnapshot snap) {
      locations.add(LocationModel.fromSnap(snap));
    });
    print("AJUNGH");
    return locations;
  }

  Future<List<Map<LocationModel, List<String>>>> getMapOfLocations() async {
    List<Map<LocationModel, List<String>>> myWanted = [];
    List<LocationModel> locations = await getListOfLocations();

    List<String> sports = [];
    String sp = "";

    for (var loc in locations) {
      print("ENTERING WITH: Location ${loc.name}");
      for (var sport in loc.sports) {
        // print("ENTERING - id is : ${sport["sport"]}");
        if (sport["matches"] > 0) {
          sp = await SportServices().getSportNameBasedOfId(sport["sport"]);
          sports.add(sp);
        }
        // print("ENTERING - name is $sp");
      }

      Map<LocationModel, List<String>> map = {
        loc: sports,
      };
      myWanted.add(map);
      sports = [];
    }
    print("ENTERING: ${myWanted.length}");
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
