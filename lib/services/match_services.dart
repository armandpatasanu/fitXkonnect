import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitxkonnect/models/hp_match_model.dart';
import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/models/match_model.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/services/location_services.dart';
import 'package:fitxkonnect/services/user_services.dart';
import 'package:flutter/material.dart';

class MatchServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<MatchModel>> getMatchesBasedOnLocation(String locationId) async {
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

  Future<List<MatchModel>> getAllHomePageMatches() async {
    var ref = await FirebaseFirestore.instance
        .collection('matches')
        .orderBy('datePublished', descending: true)
        .get();

    List<DocumentSnapshot> documentList = ref.docs;
    List<MatchModel> wantedMatches = [];

    documentList.forEach((DocumentSnapshot snap) {
      MatchModel m = MatchModel.fromSnap((snap));
      if (m.status == 'open') {
        wantedMatches.add(m);
      }
    });
    return wantedMatches;
  }

  Future<List<HomePageMatch>> getActualHomePageMatches() async {
    List<MatchModel> allMatches = await MatchServices().getAllHomePageMatches();
    print(' ok : ${allMatches.length}');
    List<HomePageMatch> neededMatches = [];

    for (var match in allMatches) {
      print("Entering with ${match.sport}");
      UserModel user = await UserServices().getSpecificUser(match.player1);
      LocationModel location =
          await LocationServices().getCertainLocation(match.location);
      neededMatches.add(HomePageMatch(
          p1Name: user.fullName,
          p1Age: user.age,
          p1Profile: user.profilePhoto,
          sport: match.sport,
          difficulty: match.difficulty,
          matchDate: match.startingTime,
          startingTime: match.matchDate,
          locationName: location.name,
          matchId: match.matchId));
      print("Adding");
    }
    return neededMatches;
  }

  Future<List<MatchModel>> getListOfMatches() async {
    var ref = await FirebaseFirestore.instance.collection('matches').get();
    List<DocumentSnapshot> documentList = ref.docs;
    List<MatchModel> wantedMatches = [];

    documentList.forEach((DocumentSnapshot snap) {
      wantedMatches.add(MatchModel.fromSnap(snap));
    });
    return wantedMatches;
  }

  Future<List<String>> getUsersActiveMatches(String userId) async {
    print("WTF?");
    List<String> meMatches = [];
    UserModel me = await UserServices().getSpecificUser(userId);

    me.sports.forEach((element) {
      print("Element: ${element}");
      meMatches.add(element);
    });
    return meMatches;
  }

  Future<List<MatchModel>> getUsersEndedMatches(List<String> s) async {
    List<MatchModel> endedMatches = [];
    s.forEach((element) async {
      MatchModel usersMatch = MatchModel.fromSnap((await _firestore
              .collection('matches')
              .where('matchId', isEqualTo: element)
              .get())
          .docs[0]);
      if (usersMatch.status == 'decided' || usersMatch.status == 'abandoned') {
        print("lmax : ${usersMatch.location}");
        endedMatches.add(usersMatch);
      }
    });
    return endedMatches;
  }

  Future<List<MatchModel>> getUserToComeMatches(List<String> s) async {
    List<MatchModel> endedMatches = [];
    s.forEach((element) async {
      MatchModel usersMatch = MatchModel.fromSnap((await _firestore
              .collection('matches')
              .where('matchId', isEqualTo: element)
              .get())
          .docs[0]);
      if (usersMatch.status == 'open') {
        print("lmax : ${usersMatch.location}");
        endedMatches.add(usersMatch);
      }
    });
    return endedMatches;
  }

  Future<int> getNumberOfMatchesOpenBasedOnLocation(String location) async {
    int myRes;
    var result = await _firestore
        .collection('matches')
        .where('location', isEqualTo: location)
        .where('status', isEqualTo: 'open')
        .get();

    myRes = result.docs.length;
    return myRes;
  }

  Future<void> cancelMatch(String matchId) async {
    try {
      await _firestore.collection('matches').doc(matchId).delete();
    } catch (error) {
      print(error.toString());
    }
  }
}
