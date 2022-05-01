import 'package:cloud_firestore/cloud_firestore.dart';

class SportModel {
  final String sportId;
  final String name;

  const SportModel({
    required this.sportId,
    required this.name,
  });

  static SportModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return SportModel(
      sportId: snapshot["sportId"],
      name: snapshot["name"],
    );
  }

  Map<String, dynamic> toJson() => {
        "sportId": sportId,
        "name": name,
      };
}
