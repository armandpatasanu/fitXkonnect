import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitxkonnect/models/match_model.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createMatch(
    String matchId,
    String location,
    String player1,
    String startingTime,
    String sport,
    String difficulty,
  ) async {
    String result = "whatever";

    try {
      String matchId = const Uuid().v1();
      MatchModel match = MatchModel(
        matchId: matchId,
        location: location,
        player1: player1,
        player2: "",
        startingTime: startingTime,
        datePublished: DateTime.now(),
        sport: sport,
        difficulty: difficulty,
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
