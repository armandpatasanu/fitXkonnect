import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitxkonnect/models/dp_match_model.dart';
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
    print("AJUNG AICI#########");
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
    print("NU CRAP DUPA SWITCH#########");
    list.forEach((element) {
      print("SUNT IN LISTA!##");
      hour = int.parse(element.matchDate.substring(0, 2));
      print("LOLX $hour");
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
          matchDate: match.startingTime,
          startingTime: match.matchDate,
          locationName: location.name,
          matchId: match.matchId));
    }
    if (diffFilter != "all") {}
    return neededMatches;
  }

  Future<List<DetailsPageMatch>> getActualDetailsPageMatches(
      String locationId) async {
    List<MatchModel> allMatches =
        await MatchServices().getMatchesBasedOnLocation(locationId);
    print(' details matches: ${allMatches.length}');
    List<DetailsPageMatch> neededMatches = [];

    for (var match in allMatches) {
      print("Entering with ${match.sport}");
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
          matchDate: match.startingTime,
          startingTime: match.matchDate,
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

  Future<List<MatchModel>> getUserEndedMatches(String userId) async {
    print(userId);
    // List<String> usersUIDS = await UserServices().getListOfUsersUIDS();
    List<MatchModel> generalMatches = await MatchServices().getListOfMatches();
    List<MatchModel> endedMatches = [];
    generalMatches.forEach((element) async {
      if ((element.status == 'decided') &&
          (element.player1 == userId || element.player2 == userId)) {
        endedMatches.add(element);
      }
    });
    return endedMatches;
  }

  Future<List<MatchModel>> getUserToComeMatches(String userId) async {
    print(userId);
    // List<String> usersUIDS = await UserServices().getListOfUsersUIDS();
    List<MatchModel> generalMatches = await MatchServices().getListOfMatches();
    List<MatchModel> endedMatches = [];
    generalMatches.forEach((element) async {
      if ((element.status == 'open' || element.status == 'matched') &&
          (element.player1 == userId || element.player2 == userId)) {
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
