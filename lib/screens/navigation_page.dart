// import 'package:bottom_navy_bar/bottom_navy_bar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:fitxkonnect/models/location_model.dart';
// import 'package:fitxkonnect/models/match_model.dart';
// import 'package:fitxkonnect/providers/user_provider.dart';
// import 'package:fitxkonnect/screens/add_match_page.dart';
// import 'package:fitxkonnect/screens/home_page.dart';
// import 'package:fitxkonnect/screens/profile_page.dart';
// import 'package:fitxkonnect/screens/search_page.dart';
// import 'package:fitxkonnect/services/location_services.dart';
// import 'package:fitxkonnect/services/match_services.dart';
// import 'package:fitxkonnect/utils/widgets/navi_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class NavigationPage extends StatefulWidget {
//   const NavigationPage({Key? key}) : super(key: key);

//   @override
//   State<NavigationPage> createState() => _NavigationPageState();
// }

// class _NavigationPageState extends State<NavigationPage> {
//   // int index = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // body: buildBody(context),
//       bottomNavigationBar: NaviBar(),
//     );
//   }

//   _storeNotificationToke() async {
//     String? token = await FirebaseMessaging.instance.getToken();
//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .set(
//       {'token': token},
//       SetOptions(merge: true),
//     );
//   }

//   addData() async {
//     UserProvider _userProvider = Provider.of(context, listen: false);
//     await _userProvider.refreshUser();
//   }

//   @override
//   void initState() {
//     addData();
//     super.initState();
//     _storeNotificationToke();
//   }

//   // void buildBody(BuildContext context) {
//   //   switch (index) {
//   //     case 1:
//   //       Navigator.of(context).pushReplacement(
//   //         PageRouteBuilder(
//   //           pageBuilder: (context, animation1, animation2) => SearchPage(),
//   //           transitionDuration: Duration(),
//   //         ),
//   //       );
//   //       break;
//   //     case 2:
//   //       Navigator.of(context).pushReplacement(
//   //         PageRouteBuilder(
//   //           pageBuilder: (context, animation1, animation2) => AddMatchPage(),
//   //           transitionDuration: Duration(),
//   //         ),
//   //       );
//   //       break;
//   //     case 3:
//   //       Navigator.of(context).pushReplacement(
//   //         PageRouteBuilder(
//   //           pageBuilder: (context, animation1, animation2) => ProfilePage(),
//   //           transitionDuration: Duration(),
//   //         ),
//   //       );
//   //       break;
//   //     // default:
//   //     //   return FutureBuilder(
//   //     //       future: MatchServices().getHomePageMatches(),
//   //     //       builder: (BuildContext context,
//   //     //           AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//   //     //         if (snapshot.connectionState == ConnectionState.waiting) {
//   //     //           return const Center(
//   //     //             child: CircularProgressIndicator(),
//   //     //           );
//   //     //         }
//   //     //         return HomePage(snapshot: snapshot);
//   //     //       });
//   //     default:
//   //       Navigator.of(context).pushReplacement(
//   //         PageRouteBuilder(
//   //           pageBuilder: (context, animation1, animation2) => HomePage(),
//   //           transitionDuration: Duration(),
//   //         ),
//   //       );
//   //   }
//   // }

//   // Widget buildBottomNavigationBar() {
//   //   return BottomNavyBar(
//   //     backgroundColor: Colors.black,
//   //     containerHeight: 60,
//   //     selectedIndex: index,
//   //     items: <BottomNavyBarItem>[
//   //       BottomNavyBarItem(
//   //         icon: Icon(Icons.home),
//   //         title: Text('Home'),
//   //         textAlign: TextAlign.center,
//   //         activeColor: Colors.green,
//   //         inactiveColor: Colors.grey,
//   //       ),
//   //       BottomNavyBarItem(
//   //         icon: Icon(Icons.search),
//   //         title: Text('Search'),
//   //         textAlign: TextAlign.center,
//   //         activeColor: Colors.amber,
//   //         inactiveColor: Colors.grey,
//   //       ),
//   //       BottomNavyBarItem(
//   //         icon: Icon(Icons.add),
//   //         title: Text('Create'),
//   //         textAlign: TextAlign.center,
//   //         activeColor: Colors.red,
//   //         inactiveColor: Colors.grey,
//   //       ),
//   //       BottomNavyBarItem(
//   //         icon: Icon(Icons.people),
//   //         title: Text('My Account'),
//   //         textAlign: TextAlign.center,
//   //         activeColor: Colors.yellow,
//   //         inactiveColor: Colors.grey,
//   //       ),
//   //     ],
//   //     onItemSelected: (index) => setState(() {
//   //       this.index = index;
//   //       buildBody(context);
//   //     }),
//   //   );
//   // }
// }
