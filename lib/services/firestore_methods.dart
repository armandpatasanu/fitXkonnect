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

        print("DEBUG: Avem locatia ${matchLocation.name}");
        List locations_sports = matchLocation.sports;
        print("DEBUG: ----------------------");
        locations_sports.forEach((element) {
          print("DEBUG SPORT: {${element["sport"]} , ${element["matches"]}}");
        });
        print("DEBUG: ----------------------");
        bool found = false;
        int numberOfMatches;
        print("DEBUG : MY SPORT ${sportId}");
        print("DEBUG: ----------------------");
        locations_sports.forEach((element) {
          if (element["sport"] == sportId) {
            print("DEBUG: MATCHED WITH ${element["sport"]}");
            found = true;
            numberOfMatches = element["matches"] + 1;
            print("DEBUG : THE NEW NUMBER: ${numberOfMatches}");
            element.update("matches", (value) => numberOfMatches);
          }
        });

        print("DEBUG: ----------------------");
        if (found == true) {
          print("DEBUG: AM GASIT SPORTUL SI AM INTRAT AICI");
          _firestore
              .collection('locations')
              .doc(locationId)
              .update({'sports': locations_sports});
        } else {
          print("DEBUG: SPORT NOU");
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
