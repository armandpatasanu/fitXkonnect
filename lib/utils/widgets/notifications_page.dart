import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('receiver',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          print("lamo :${snapshot.data.docs.length}");
          return Scaffold(
            body: snapshot.data.docs.length == 0
                ? Container(
                    // color: Colors.grey[100],
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            height: 200,
                            width: 200,
                            child: Image.asset(
                                'assets/images/notif_screen/no_notifications.png',
                                fit: BoxFit.cover),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.9,
                          right: 20,
                          child: Material(
                            shape: CircleBorder(),
                            color: Colors.white,
                            child: Center(
                              child: Ink(
                                decoration: const ShapeDecoration(
                                  color: Colors.black,
                                  shape: CircleBorder(),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.home),
                                  color: Colors.white,
                                  onPressed: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ProfilePage())),
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Stack(
                      children: [
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 60,
                                      child: Icon(
                                        Icons.notification_add,
                                        color: Colors.black,
                                        size: 38,
                                      ),
                                      decoration: BoxDecoration(
                                        // color: Colors.amber,
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          118,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data.docs[index]
                                                .get('notifTitle'),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'OpenSans',
                                                fontSize: 18),
                                          ),
                                          Divider(
                                            color: Colors.black,
                                            thickness: 1,
                                          ),
                                          Text(
                                              snapshot.data.docs[index]
                                                  .get('notifText'),
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'OpenSans',
                                                  fontSize: 12)),
                                        ],
                                      ),
                                      // color: Colors.red,
                                    )
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(20)),
                                height: 100,
                              ),
                            );
                          },
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.9,
                          right: 20,
                          child: Material(
                            shape: CircleBorder(),
                            color: Colors.white,
                            child: Center(
                              child: Ink(
                                decoration: const ShapeDecoration(
                                  color: Colors.black,
                                  shape: CircleBorder(),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.home),
                                  color: Colors.white,
                                  onPressed: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ProfilePage())),
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        });
  }
}
