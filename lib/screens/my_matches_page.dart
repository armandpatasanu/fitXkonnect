import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitxkonnect/main.dart';
import 'package:fitxkonnect/models/full_match_model.dart';
import 'package:fitxkonnect/models/hp_match_model.dart';
import 'package:fitxkonnect/models/match_model.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/screens/profile_page.dart';
import 'package:fitxkonnect/services/location_services.dart';
import 'package:fitxkonnect/services/match_services.dart';
import 'package:fitxkonnect/services/storage_methods.dart';
import 'package:fitxkonnect/services/user_services.dart';
import 'package:fitxkonnect/utils/colors.dart';
import 'package:fitxkonnect/utils/components/profile_page/profile_pic.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/rating_bar.dart';
import 'package:fitxkonnect/utils/utils.dart';
import 'package:fitxkonnect/utils/widgets/full_match_widget.dart';
import 'package:fitxkonnect/utils/widgets/open_match_widget.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class MyMatchesPage extends StatefulWidget {
  final UserModel user;
  const MyMatchesPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _MyMatchesPageState createState() => _MyMatchesPageState();
}

class _MyMatchesPageState extends State<MyMatchesPage> {
  UserModel _userData = StorageMethods().getEmptyUser();

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: UserServices()
          .getSpecificUser(FirebaseAuth.instance.currentUser!.uid),
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Stack(children: [
          DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                //centerTitle: true,
                toolbarHeight: 10,
                //backgroundColor: Colors.purple,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple, Colors.red],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                    ),
                  ),
                ),
                bottom: TabBar(
                  //isScrollable: true,
                  indicatorColor: Colors.white,
                  indicatorWeight: 5,
                  tabs: [
                    Tab(icon: Icon(Icons.games), text: 'UpComing '),
                    Tab(icon: Icon(Icons.games), text: 'Opened '),
                    Tab(
                      icon: Icon(Icons.history),
                      text: 'History',
                    ),
                  ],
                ),
                elevation: 30,
                titleSpacing: 50,
              ),
              body: TabBarView(
                children: [
                  FutureBuilder<List<FullMatch>>(
                      future: MatchServices().getUsersMatched(
                          FirebaseAuth.instance.currentUser!.uid),
                      initialData: [],
                      builder: (BuildContext context,
                          AsyncSnapshot<List<FullMatch>> snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            !snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return createMatchesListView(context, snapshot);
                      }),
                  FutureBuilder<List<HomePageMatch>>(
                      future: MatchServices().getUserOpenMatches(
                          FirebaseAuth.instance.currentUser!.uid),
                      initialData: [],
                      builder: (BuildContext context,
                          AsyncSnapshot<List<HomePageMatch>> snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            !snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return createOpenMatchesListView(context, snapshot);
                      }),
                  FutureBuilder<List<FullMatch>>(
                      future: MatchServices().getUserEndedMatches(
                          FirebaseAuth.instance.currentUser!.uid),
                      initialData: [],
                      builder: (BuildContext context,
                          AsyncSnapshot<List<FullMatch>> snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            !snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return createDecidedMatchesListView(context, snapshot);
                      }),
                ],
              ),
            ),
          ),
          Positioned(
            top: 700,
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
                              builder: (context) => const ProfilePage())),
                    },
                  ),
                ),
              ),
            ),
          ),
        ]);
      });

  Widget createMatchesListView(
      BuildContext context, AsyncSnapshot<List<FullMatch>> snapshot) {
    var values = snapshot.data!;
    return values.length == 0
        ? Text(
            'No matches yet!',
            style: TextStyle(color: kPrimaryColor),
          )
        : ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: values.length,
            itemBuilder: (BuildContext context, int index) {
              return values.isNotEmpty
                  ? FullMatchCard(match: values[index])
                  : CircularProgressIndicator();
            },
          );
  }

  Widget createDecidedMatchesListView(
      BuildContext context, AsyncSnapshot<List<FullMatch>> snapshot) {
    var values = snapshot.data!;

    return values.length == 0
        ? Text(
            'No matches yet!',
            style: TextStyle(color: kPrimaryColor),
          )
        : ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: values.length,
            itemBuilder: (BuildContext context, int index) {
              return values.isNotEmpty
                  ? FullMatchCard(match: values[index])
                  : CircularProgressIndicator();
            },
          );
  }

  Widget createOpenMatchesListView(
      BuildContext context, AsyncSnapshot<List<HomePageMatch>> snapshot) {
    var values = snapshot.data!;
    return values.length == 0
        ? Text(
            'No matches yet!',
            style: TextStyle(color: kPrimaryColor),
          )
        : ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: values.length,
            itemBuilder: (BuildContext context, int index) {
              return values.isNotEmpty
                  ? OpenMatchCard(match: values[index])
                  : CircularProgressIndicator();
            },
          );
  }
}
