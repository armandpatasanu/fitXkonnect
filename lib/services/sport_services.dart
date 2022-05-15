import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitxkonnect/models/sport_model.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/services/user_services.dart';

class SportServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<SportModel>> getListOfSports() async {
    var ref = await FirebaseFirestore.instance
        .collection('sports')
        .orderBy('name', descending: false)
        .get();
    List<DocumentSnapshot> locationList = ref.docs;
    List<SportModel> locations = [];

    locationList.forEach((DocumentSnapshot snap) {
      locations.add(SportModel.fromSnap(snap));
    });

    return locations;
  }

  Future<SportModel> getSpecificSportFromId(String sportId) async {
    var result = await _firestore.collection('sports').doc(sportId).get();

    SportModel searchedSport = SportModel.fromSnap(result);
    return searchedSport;
  }

  Future<SportModel> getSpecificSportFromName(String sportName) async {
    List<SportModel> sports = await getListOfSports();
    String searchedSportId = "";

    sports.forEach((element) {
      if (element.name == sportName) {
        searchedSportId = element.sportId;
      }
    });
    var result =
        await _firestore.collection('sports').doc(searchedSportId).get();

    SportModel searchedSport = SportModel.fromSnap(result);
    return searchedSport;
  }

  Future<List<dynamic>> getUsersSportsPlayed(String userId) async {
    print("HELLO?");
    UserModel user = await UserServices().getSpecificUser(userId);
    List users_sports = user.sports;
    for (var map in users_sports) {
      print(map['sport']);
      print(map['difficulty']);
      map['sport'] =
          (await SportServices().getSpecificSportFromId(map['sport']!)).name;
      print(map['sport']);
    }
    return users_sports;
  }

  Future<void> addSport(String uid, String dif, String sport) async {
    UserModel user = await UserServices().getSpecificUser(uid);
    List users_sports = user.sports;
    String sportId =
        (await SportServices().getSpecificSportFromName(sport)).sportId;
    Map<String, String> map = {
      'difficulty': dif,
      'sport': sportId,
    };
    users_sports.add(map);
    _firestore
        .collection('users')
        .doc(uid)
        .update({'sports': FieldValue.arrayUnion(users_sports)});
  }
}
