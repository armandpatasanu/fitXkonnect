import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/models/match_model.dart';
import 'package:fitxkonnect/models/sport_model.dart';
import 'package:fitxkonnect/models/user_model.dart';

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
}
