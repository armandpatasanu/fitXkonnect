import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitxkonnect/models/sport_model.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/services/user_services.dart';

class SportServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<List<SportModel>> getListOfSports() async {
    var ref = await FirebaseFirestore.instance
        .collection('sports')
        .orderBy('name', descending: false)
        .get();
    List<DocumentSnapshot> sportsList = ref.docs;
    List<SportModel> sports = [];

    sportsList.forEach((DocumentSnapshot snap) {
      sports.add(SportModel.fromSnap(snap));
    });

    return sports;
  }

  Future<List<Map<String, bool>>> getButtonsSports() async {
    List<SportModel> sports = await getListOfSports();
    List<Map<String, bool>> myList = [];

    sports.forEach((SportModel snap) {
      Map<String, bool> map = {
        '${snap.name}': false,
      };
      myList.add(map);
    });

    print("My list items: ${myList.length}");
    print("VALOARE: ${myList[0].values.first}");
    return myList;
  }

  Future<String> getSportIdBasedOfName(String name) async {
    var ref = await FirebaseFirestore.instance.collection('sports').get();
    List<DocumentSnapshot> documentList = ref.docs;
    String wantedId = "";
    print("Y1");
    for (var snap in documentList) {
      print("Y2");
      if (snap['name'] == name) {
        print(snap['name']);
        print("Y3");
        wantedId =
            (await SportServices().getSpecificSportFromName(snap['name']))
                .sportId;
        print("AM GASIT BOI: $wantedId");
      }
    }
    ;
    return wantedId;
  }

  Future<List<String>> getDifferentSports(uid) async {
    List<dynamic> playedSports = await getUsersSportsPlayed(uid);
    List<String> playedSports_strings = [];
    List<SportModel> allSports = await getListOfSports();
    List<String> allSports_strings = [];
    List<String> wantedSports = [];

    for (var map in playedSports) {
      playedSports_strings.add(map['sport']);
      print("sport care e configurat: ${playedSports_strings}");
    }

    for (var sport in allSports) {
      allSports_strings.add(sport.name);
      print("sport care e configurat: ${allSports_strings}");
    }

    for (var name in allSports_strings) {
      if (!playedSports_strings.contains(name)) {
        print("Sport care nu e: $name");
        wantedSports.add(name);
      }
    }
    return wantedSports;
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
