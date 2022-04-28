import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String uid;
  final String profilePhoto;
  final String username;
  final String fullName;
  final String country;

  const UserModel({
    required this.username,
    required this.uid,
    required this.profilePhoto,
    required this.email,
    required this.fullName,
    required this.country,
  });

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      uid: snapshot["uid"],
      username: snapshot["username"],
      fullName: snapshot["fullName"],
      email: snapshot["email"],
      profilePhoto: snapshot["profilePhoto"],
      country: snapshot["country"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "profilePhoto": profilePhoto,
        "fullName": fullName,
        "country": country,
      };
}
