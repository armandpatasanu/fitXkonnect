import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitxkonnect/models/notification_model.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/services/user_services.dart';
import 'package:fitxkonnect/utils/utils.dart';
import 'package:flutter/material.dart';

import '../models/match_model.dart';

class NotifSerivces {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> storeNotif(String? notifId, String? title, String? text,
      String? currentUser, int type, UserModel sender, MatchModel match) async {
    Notif notif = Notif(
        datePublished: DateTime.now(),
        notifId: notifId!,
        notifTitle: title!,
        notifText: text!,
        receiver: currentUser!,
        type: type);
    await _firestore.collection('notifications').doc(notifId).set(
          notif.toJson(),
        );
  }

  void sendSchedule(int interval, String? body, int matchNotifId) async {
    int id = createUniqueId();
    String timezone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
    AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: matchNotifId,
          channelKey: 'scheduled_channel',
          title: 'New match ahead! - 1 hour left!',
          body: body,
          notificationLayout: NotificationLayout.Default,
        ),
        schedule: NotificationInterval(
          interval: interval,
          timeZone: timezone,
        ));
  }

//   Future<void> handleNotif() async {
//     print("oke ajung?");

//     List<String> notifications = [];
//     // String time
// storeNotif
//     // notifications.add(notifId);

//     // _firestore
//     //     .collection('users')
//     //     .doc(currentUser)
//     //     .update({'notifications': FieldValue.arrayUnion(notifications)});
//     String timezone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
//     int id = createUniqueId();
//     print("GOT HERE");
//     print("LOL ${match.matchDate} ${match.startingTime}::00");
//     AwesomeNotifications().createNotification(
//         content: NotificationContent(
//           id: id,
//           channelKey: 'scheduled_channel',
//           title: 'New match ahead! - 25 sec',
//           body: "You matched with ${u.fullName}",
//           notificationLayout: NotificationLayout.Default,
//         ),
//         schedule: NotificationInterval(
//           interval: 15,
//           timeZone: timezone,
//         ));
//     // schedule: NotificationCalendar.fromDate(
//     //     date: DateTime.parse("2022-06-13 12:05::00")));
//   }
}
