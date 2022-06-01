import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitxkonnect/models/match_model.dart';
import 'package:fitxkonnect/services/location_services.dart';
import 'package:fitxkonnect/services/sport_services.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createMatch(
    String player1,
    String locationName,
    String matchDate,
    String startingTime,
    String sport,
    String difficulty,
    String status,
  ) async {
    String result = "whatever";

    try {
      String matchId = const Uuid().v1();
      String locationId = await LocationServices().getLocationId(locationName);
      String sportId = await SportServices().getSportIdBasedOfName(sport);
      MatchModel match = MatchModel(
        matchId: matchId,
        location: locationId,
        player1: player1,
        player2: "",
        matchDate: matchDate,
        startingTime: startingTime,
        datePublished: DateTime.now(),
        sport: sport,
        difficulty: difficulty,
        status: status,
      );

      List<String> sports = [];
      sports.add(sportId);
      _firestore
          .collection('locations')
          .doc(locationId)
          .update({'sports': FieldValue.arrayUnion(sports)});

      _firestore.collection('matches').doc(matchId).set(
            match.toJson(),
          );
      result = "success";
    } catch (error) {
      result = error.toString();
    }

    return result;
  }
}
