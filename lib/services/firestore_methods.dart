import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitxkonnect/models/match_model.dart';
import 'package:fitxkonnect/services/location_services.dart';
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
      MatchModel match = MatchModel(
        matchId: matchId,
        location: await LocationServices().getLocationId(locationName),
        player1: player1,
        player2: "",
        matchDate: matchDate,
        startingTime: startingTime,
        datePublished: DateTime.now(),
        sport: sport,
        difficulty: difficulty,
        status: status,
      );

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
