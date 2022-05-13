import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitxkonnect/models/hp_match_model.dart';
import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/providers/user_provider.dart';
import 'package:fitxkonnect/screens/navigation_page.dart';
import 'package:fitxkonnect/services/location_services.dart';
import 'package:fitxkonnect/services/match_services.dart';
import 'package:fitxkonnect/services/storage_methods.dart';
import 'package:fitxkonnect/services/user_services.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/personal_match_card.dart';
import 'package:fitxkonnect/utils/widgets/match_card.dart';
import 'package:fitxkonnect/utils/widgets/navi_bar.dart';
import 'package:fitxkonnect/utils/widgets/special_match_card.dart';
import 'package:flutter/material.dart';
import 'package:multi_stream_builder/multi_stream_builder.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  // final snapshot;
  const HomePage({
    Key? key,
    // this.snapshot,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserModel _userData = StorageMethods().getEmptyUser();
  LocationModel _locationData = StorageMethods().getEmptyLocation();
  String _searchedPlayer1Id = "";
  String _certainLocationId = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getUser();
    // getLocation();
    // addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  Future<UserModel> getUser() async {
    _userData = await UserServices().getSpecificUser(_searchedPlayer1Id);
    // setState(() {});
    return _userData;
  }

  Future<LocationModel> getLocation() async {
    _locationData =
        await LocationServices().getCertainLocation(_certainLocationId);
    // setState(() {});
    return _locationData;
  }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: kPrimaryLightColor,
//         elevation: 0,
//       ),
//       backgroundColor: Colors.white,
//       body: getBody(),
//     );
//   }

//   Widget getBody() {
//     return FutureBuilder(
//         future: MatchServices().getHomePageMatches(),
//         initialData: [],
//         builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           return createMatchesListView(context, snapshot);
//         });
//   }

//   Widget createMatchesListView(BuildContext context, AsyncSnapshot snapshot) {
//     var values = snapshot.data;
//     print("NUMERO DE MATCHES: ${values.length}");
//     return ListView.builder(
//       scrollDirection: Axis.vertical,
//       itemCount: values.length,
//       itemBuilder: (BuildContext context, int index) {
//         _searchedPlayer1Id = values[index].player1;
//         _certainLocationId = values[index].location;
//         return values.isNotEmpty
//             ? FutureBuilder(
//                 future: Future.wait([
//                   UserServices().getSpecificUser(_searchedPlayer1Id),
//                   LocationServices().getCertainLocation(_certainLocationId),
//                 ]),
//                 builder:
//                     (BuildContext context, AsyncSnapshot<List<dynamic>> sneps) {
//                   if (sneps.connectionState == ConnectionState.waiting) {
//                     return const Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   } else if (!sneps.hasData) {
//                     return Container(
//                       child: Center(
//                         child: CircularProgressIndicator(),
//                       ),
//                     );
//                   }

//                   return SpecialMatchCard(
//                     snap: values[index],
//                     userSnap: sneps.data![0],
//                     locationSnap: sneps.data![1],
//                   );
//                 })
//             : CircularProgressIndicator();
//       },
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: MatchServices().getActualHomePageMatches(),
        builder: (BuildContext context,
            AsyncSnapshot<List<HomePageMatch>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
            bottomNavigationBar: NaviBar(
              index: 0,
            ),
            body: Container(
              child: Column(children: [
                Container(
                  height: 120,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(50),
                    ),
                    color: Color.fromARGB(47, 143, 116, 36),
                  ),
                  child: Stack(children: [
                    Positioned(
                      top: 40,
                      left: 0,
                      child: Container(
                        height: 60,
                        width: 300,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          ),
                          color: kPrimaryLightColor,
                        ),
                      ),
                    ),
                    // Positioned(
                    //   top: 40,
                    //   left: 4,
                    //   child: TextButton.icon(
                    //     label: Text(
                    //       "Available Matches",
                    //       style: TextStyle(
                    //         fontSize: 24,
                    //         color: Color.fromARGB(180, 69, 36, 255),
                    //         fontFamily: 'OpenSans',
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //     icon: Icon(
                    //       Icons.arrow_circle_left,
                    //       color: Color.fromARGB(180, 112, 91, 232),
                    //     ),
                    //     onPressed: () => Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => const NavigationPage())),
                    //   ),
                    // ),
                  ]),
                ),
                Expanded(
                  child: SizedBox(
                    height: 10,
                    child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) => SpecialMatchCard(
                              snap: snapshot.data![index],
                            )
                        // itemBuilder: (context, index) => Text(
                        //   'this is $index',
                        //   style: TextStyle(color: kPrimaryColor),
                        // ),
                        ),
                  ),
                ),
              ]),
            ),
          );
        });

    // Future<Widget> _getHomeMatchesList() async {
    //   print("lol");
    // }
  }
}
