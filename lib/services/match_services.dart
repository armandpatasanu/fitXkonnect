import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitxkonnect/models/dp_match_model.dart';
import 'package:fitxkonnect/models/full_match_model.dart';
import 'package:fitxkonnect/models/hp_match_model.dart';
import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/models/match_model.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/services/location_services.dart';
import 'package:fitxkonnect/services/sport_services.dart';
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

  Future<List<MatchModel>> getMatchesBasedOnSport(String sportName) async {
    List<MatchModel> wantedMatches = [];
    // String sportId = await SportServices().getSportIdBasedOfName(sportName);
    var ref = await FirebaseFirestore.instance
        .collection('matches')
        .where('sport', isEqualTo: sportName)
        .get();

    List<DocumentSnapshot> documentList = ref.docs;

    documentList.forEach((DocumentSnapshot snap) {
      MatchModel m = MatchModel.fromSnap((snap));
      if (m.status == 'open') {
        wantedMatches.add(m);
      }
    });
    return wantedMatches;
  }

  List<MatchModel> getMatchesBasedOnDifficulty(
      String diff, List<MatchModel> list) {
    List<MatchModel> wantedMatches = [];
    list.forEach((element) {
      if (element.difficulty == diff) {
        wantedMatches.add(element);
      }
    });
    return wantedMatches;
  }

  List<MatchModel> getMatchesBasedOnDay(String diff, List<MatchModel> list) {
    List<MatchModel> wantedMatches = [];
    int startingHour = 99;
    int finishHour = 99;
    int hour = 0;
    switch (diff) {
      case 'Morning':
        startingHour = 8;
        finishHour = 13;
        break;
      case 'Afternoon':
        startingHour = 13;
        finishHour = 19;
        break;
      case 'Night':
        startingHour = 19;
        finishHour = 24;
        break;
    }

    list.forEach((element) {
      hour = int.parse(element.startingTime.substring(0, 2));
      if (hour <= finishHour && hour >= startingHour) {
        wantedMatches.add(element);
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

  Future<List<MatchModel>> getAllFullMatches() async {
    var ref = await FirebaseFirestore.instance
        .collection('matches')
        .orderBy('datePublished', descending: true)
        .get();

    List<DocumentSnapshot> documentList = ref.docs;

    List<MatchModel> wantedMatches = [];

    documentList.forEach((DocumentSnapshot snap) {
      MatchModel m = MatchModel.fromSnap((snap));

      if (m.status == 'decided') {
        wantedMatches.add(m);
      }
    });

    return wantedMatches;
  }

  Future<List<HomePageMatch>> getActualHomePageMatches(
      String sportFilter, String diffFilter, String dayFilter) async {
    List<MatchModel> filteredOnce = [];
    if (sportFilter == "all") {
      filteredOnce = await MatchServices().getAllHomePageMatches();
    } else {
      filteredOnce = await MatchServices().getMatchesBasedOnSport(sportFilter);
    }
    List<MatchModel> filteredTwice = [];
    if (diffFilter == "all") {
      filteredTwice = filteredOnce;
    } else {
      filteredTwice =
          MatchServices().getMatchesBasedOnDifficulty(diffFilter, filteredOnce);
    }
    List<MatchModel> filteredThird = [];
    if (dayFilter == "all") {
      filteredThird = filteredTwice;
    } else {
      filteredThird =
          MatchServices().getMatchesBasedOnDay(dayFilter, filteredTwice);
    }
    List<HomePageMatch> neededMatches = [];

    for (var match in filteredThird) {
      UserModel user = await UserServices().getSpecificUser(match.player1);
      LocationModel location =
          await LocationServices().getCertainLocation(match.location);
      neededMatches.add(HomePageMatch(
          p1uid: user.uid,
          p1Name: user.fullName,
          p1Age: user.age,
          p1Profile: user.profilePhoto,
          sport: match.sport,
          difficulty: match.difficulty,
          matchDate: match.matchDate,
          startingTime: match.startingTime,
          locationName: location.name,
          matchId: match.matchId));
    }
    return neededMatches;
  }

  Future<List<MatchModel>> getFullMatches() async {
    List<MatchModel> matches = await MatchServices().getListOfMatches();
    List<MatchModel> fullMatches = [];
    for (var m in matches) {
      if (m.player2 != "") {
        fullMatches.add(m);
      }
    }
    return fullMatches;
  }

  Future<List<FullMatch>> getActualFullMatches() async {
    List<MatchModel> fullMatches = await getFullMatches();

    List<FullMatch> neededMatches = [];
    for (var match in fullMatches) {
      UserModel user1 = await UserServices().getSpecificUser(match.player1);
      UserModel user2 = await UserServices().getSpecificUser(match.player2);
      LocationModel location =
          await LocationServices().getCertainLocation(match.location);
      neededMatches.add(FullMatch(
        p1uid: user1.uid,
        p1Name: user1.fullName,
        p1Age: user1.age,
        p1Country: user1.country,
        p1Profile: user1.profilePhoto,
        p2uid: user2.uid,
        p2Name: user2.fullName,
        p2Age: user2.age,
        p2Country: user2.country,
        p2Profile: user2.profilePhoto,
        sport: match.sport,
        difficulty: match.difficulty,
        matchDate: match.matchDate,
        startingTime: match.startingTime,
        locationName: location.name,
        matchId: match.matchId,
        status: match.status,
        locationAddress: location.contact[0],
      ));
    }
    return neededMatches;
  }

  Future<List<DetailsPageMatch>> getActualDetailsPageMatches(
      String locationId) async {
    List<MatchModel> allMatches =
        await MatchServices().getMatchesBasedOnLocation(locationId);
    List<DetailsPageMatch> neededMatches = [];

    for (var match in allMatches) {
      UserModel user = await UserServices().getSpecificUser(match.player1);
      LocationModel location =
          await LocationServices().getCertainLocation(match.location);
      neededMatches.add(DetailsPageMatch(
          p1Name: user.fullName,
          p1Age: user.age,
          p1Profile: user.profilePhoto,
          p1Country: user.country,
          sport: match.sport,
          difficulty: match.difficulty,
          matchDate: match.matchDate,
          startingTime: match.startingTime,
          matchId: match.matchId));
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

  Future<List<FullMatch>> getUserEndedMatches(String userId) async {
    List<FullMatch> generalMatches =
        await MatchServices().getActualFullMatches();
    List<FullMatch> endedMatches = [];
    generalMatches.forEach((element) async {
      if ((element.status == 'decided' || element.status == 'abandoned') &&
          (element.p1uid == userId || element.p2uid == userId)) {
        endedMatches.add(element);
      }
    });
    return endedMatches;
  }

  Future<List<HomePageMatch>> getUserOpenMatches(String userId) async {
    List<HomePageMatch> generalMatches =
        await MatchServices().getActualHomePageMatches("all", "all", "all");

    List<HomePageMatch> matchesToCome = [];
    generalMatches.forEach((element) async {
      if (element.p1uid == userId) {
        matchesToCome.add(element);
      }
    });

    return matchesToCome;
  }

  Future<List<FullMatch>> getUsersMatched(String userId) async {
    List<FullMatch> generalMatches =
        await MatchServices().getActualFullMatches();

    List<FullMatch> endedMatches = [];
    generalMatches.forEach((element) async {
      if ((element.status == 'matched') &&
          (element.p1uid == userId || element.p2uid == userId)) {
        endedMatches.add(element);
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

  Future<void> matchPlayers(String matchId, String player2Id) async {
    var collection = FirebaseFirestore.instance.collection('matches');
    collection.doc(matchId) // <-- Doc ID where data should be updated.
        .update({
      'player2': player2Id,
      'status': 'matched',
    });
  }

  Future<void> cancelMatch(String matchId) async {
    try {
      await _firestore.collection('matches').doc(matchId).delete();
    } catch (error) {
      print(error.toString());
    }
  }
}
