import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String uid;
  final String profilePhoto;
  final String age;
  final String fullName;
  final String country;
  final List matches;
  final List sports;
  final List notifications;
  final String token;

  const UserModel({
    required this.age,
    required this.uid,
    required this.profilePhoto,
    required this.email,
    required this.fullName,
    required this.country,
    required this.matches,
    required this.sports,
    required this.notifications,
    required this.token,
  });

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      uid: snapshot["uid"],
      age: snapshot["age"],
      fullName: snapshot["fullName"],
      email: snapshot["email"],
      profilePhoto: snapshot["profilePhoto"],
      country: snapshot["country"],
      matches: snapshot["matches"],
      sports: snapshot["sports"],
      notifications: snapshot["notifications"],
      token: snapshot["token"],
    );
  }

  Map<String, dynamic> toJson() => {
        "age": age,
        "uid": uid,
        "email": email,
        "profilePhoto": profilePhoto,
        "fullName": fullName,
        "country": country,
        "matches": matches,
        "sports": sports,
        "notifications": notifications,
        "token": token,
      };
}
