import 'package:firebase_core/firebase_core.dart';
import 'package:fitxkonnect/screens/profile_page.dart';
import 'package:fitxkonnect/services/fcm_notif_services.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String notificationTitle = 'No Title';
  String notificationBody = 'No Body';
  String notificationData = 'No Data';

  @override
  void initState() {
    final firebaseMessaging = FCM();
    firebaseMessaging.setNotifications();

    firebaseMessaging.streamCtlr.stream.listen(_changeData);
    firebaseMessaging.bodyCtlr.stream.listen(_changeBody);
    firebaseMessaging.titleCtlr.stream.listen(_changeTitle);

    super.initState();
  }

  // _changeData(String msg) {
  //   if (this.mounted) {
  //     setState(() {
  //       notificationData = msg;
  //     });
  //   }
  // }

  // _changeBody(String msg) {
  //   if (this.mounted) {
  //     setState(() {
  //       notificationBody = msg;
  //     });
  //   }
  // }

  // _changeTitle(String msg) {
  //   if (this.mounted) {
  //     setState(() {
  //       notificationTitle = msg;
  //     });
  //   }
  // }

  _changeData(String msg) => setState(() => notificationData = msg);
  _changeBody(String msg) => setState(() => notificationBody = msg);
  _changeTitle(String msg) => setState(() => notificationTitle = msg);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Flutter Notification Details",
            style: TextStyle(color: kPrimaryColor, fontSize: 16),
          ),
          const SizedBox(height: 20),
          Text(
            "Notification Title:-  $notificationTitle",
            style: TextStyle(color: kPrimaryColor, fontSize: 16),
          ),
          Text(
            "Notification Body:-  $notificationBody",
            style: TextStyle(color: kPrimaryColor, fontSize: 16),
          ),
          SizedBox(
            height: 30,
          ),
          Material(
            child: IconButton(
              icon: const Icon(Icons.home),
              color: Colors.white,
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage())),
              },
            ),
          ),
        ],
      ),
    );
  }
}
