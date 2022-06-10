import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/models/match_model.dart';
import 'package:fitxkonnect/services/location_services.dart';
import 'package:fitxkonnect/services/sport_services.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createMatch(
    String player1,
    String? locationName,
    String matchDate,
    String sport,
    String difficulty,
    String status,
  ) async {
    String result = "whatever";
    print("Sport is $sport");
    try {
      if (sport == "Choose a sport") {
        result = "Please select a sport!";
      } else if (locationName == null) {
        result = "Please select a location!";
      } else if (matchDate == "") {
        result = "Select a valid match date!";
      } else {
        String matchId = const Uuid().v1();
        String locationId =
            await LocationServices().getLocationId(locationName);
        String sportId = await SportServices().getSportIdBasedOfName(sport);
        MatchModel match = MatchModel(
          matchId: matchId,
          location: locationId,
          player1: player1,
          player2: "",
          matchDate: matchDate.substring(0, 10),
          startingTime: matchDate.substring(11, 16),
          datePublished: DateTime.now(),
          sport: sport,
          difficulty: difficulty,
          status: status,
        );

        LocationModel matchLocation =
            await LocationServices().getCertainLocation(locationId);
        List locations_sports = matchLocation.sports;
        bool found = false;
        int numberOfMatches;
        print("WTF : MY SPORT ${sportId}");
        locations_sports.forEach((element) {
          print("WTF : COMING SPORTS : ${element.values.last}");
          if (element.values.last == sportId) {
            print("WTF: I MATCHED");
            found = true;
            numberOfMatches = element["matches"] + 1;
            print("WTF : THE NEW NUMBER: ${numberOfMatches}");
            element.update("matches", (value) => numberOfMatches);
            // Map<String, dynamic> map = {
            //   'sport': sportId,
            //   'matches': element.values.first + 1,
            // };
            // locations_sports.add(map);
            // numberOfMatches = int.parse(element.values.first) + 1;
          }
        });

        if (found == true) {
          _firestore
              .collection('locations')
              .doc(locationId)
              .update({'sports': locations_sports});
        } else {
          print("MJ got here");
          Map<String, dynamic> map = {
            'sport': sportId,
            'matches': 1,
          };
          locations_sports.add(map);
          _firestore
              .collection('locations')
              .doc(locationId)
              .update({'sports': locations_sports});
        }

        // List<String> sports = [];
        // sports.add(sportId);
        // _firestore
        //     .collection('locations')
        //     .doc(locationId)
        //     .update({'sports': FieldValue.arrayUnion(sports)});

        _firestore.collection('matches').doc(matchId).set(
              match.toJson(),
            );

        result = "success";
      }
    } catch (error) {
      result = error.toString();
    }
    return result;
  }
}
