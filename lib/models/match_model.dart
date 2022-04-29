import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitxkonnect/models/user_model.dart';

class MatchModel {
  final String matchId;
  final String location;
  final String player1;
  final String player2;
  final String startingTime;
  final DateTime datePublished;
  final String sport;
  final String difficulty;

  const MatchModel({
    required this.matchId,
    required this.location,
    required this.player1,
    required this.player2,
    required this.startingTime,
    required this.datePublished,
    required this.sport,
    required this.difficulty,
  });

  static MatchModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return MatchModel(
        matchId: snapshot["matchId"],
        location: snapshot["location"],
        player1: snapshot["player1"],
        player2: snapshot["player2"],
        startingTime: snapshot["startingTime"],
        datePublished: snapshot["username"],
        sport: snapshot['postUrl'],
        difficulty: snapshot['difficulty']);
  }

  Map<String, dynamic> toJson() => {
        "matchId": matchId,
        "location": location,
        "player1": player1,
        "player2": player2,
        "startingTime": startingTime,
        "datePublished": datePublished,
        'sport': sport,
        'difficulty': difficulty,
      };
}
