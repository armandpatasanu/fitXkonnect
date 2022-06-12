import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitxkonnect/models/notification_model.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/services/user_services.dart';
import 'package:flutter/material.dart';

class NotifSerivces {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> handleNotif(String? notifId, String? title, String? text,
      String? currentUser, int type) async {
    print("oke ajung?");
    Notif notif = Notif(
        notifId: notifId!,
        notifTitle: title!,
        notifText: text!,
        receiver: currentUser!,
        type: type);
    _firestore.collection('notifications').doc(notifId).set(
          notif.toJson(),
        );

    UserModel u = await UserServices().getSpecificUser(currentUser);
    List<String> notifications = [];

    notifications.add(notifId);

    _firestore
        .collection('users')
        .doc(currentUser)
        .update({'notifications': FieldValue.arrayUnion(notifications)});
  }
}
