import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/models/match_model.dart';
import 'package:fitxkonnect/models/sport_model.dart';
import 'package:fitxkonnect/models/user_model.dart';
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

  Future<List<MatchModel>> getCertainMatches(String locationId) async {
    var ref = await FirebaseFirestore.instance.collection('matches').get();
    List<DocumentSnapshot> documentList = ref.docs;
    List<MatchModel> wantedMatches = [];

    documentList.forEach((DocumentSnapshot snap) {
      if (snap['location'] == locationId) {
        wantedMatches.add(MatchModel.fromSnap(snap));
      }
    });
    return wantedMatches;
  }

  Future<List<LocationModel>> getLocationsList() async {
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

  Future<List<LocationModel>> getMatchesList() async {
    var ref = await FirebaseFirestore.instance
        .collection('matches')
        .orderBy('name', descending: false)
        .get();
    List<DocumentSnapshot> matchesList = ref.docs;
    List<LocationModel> matches = [];

    matchesList.forEach((DocumentSnapshot snap) {
      matches.add(LocationModel.fromSnap(snap));
    });
    return matches;
  }

  Future<UserModel> getSpecificUser(String player1Id) async {
    var result = await _firestore
        .collection('users')
        .where('uid', isEqualTo: player1Id)
        .get();

    UserModel searchedUser = UserModel.fromSnap(result.docs[0]);
    return searchedUser;
  }

  Future<int> getLocationActiveMatches(String s) async {
    print("LAMO 2 is ${s}");
    int myRes;
    var result = await _firestore
        .collection('matches')
        .where('location', isEqualTo: s)
        .get();

    myRes = result.docs.length;
    print("LMAO IS ${myRes}");

    return myRes;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLocations() async {
    return await FirebaseFirestore.instance
        .collection("matches")
        .orderBy('datePublished', descending: true)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getMatches() async {
    return await FirebaseFirestore.instance
        .collection("matches")
        .orderBy('datePublished', descending: true)
        .get();
  }

  Future<void> cancelMatch(String matchId) async {
    try {
      await _firestore.collection('matches').doc(matchId).delete();
    } catch (error) {
      print(error.toString());
    }
  }
}
