import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitxkonnect/main.dart';
import 'package:fitxkonnect/models/match_model.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/screens/navigation_page.dart';
import 'package:fitxkonnect/screens/profile_page.dart';
import 'package:fitxkonnect/services/location_services.dart';
import 'package:fitxkonnect/services/match_services.dart';
import 'package:fitxkonnect/services/storage_methods.dart';
import 'package:fitxkonnect/services/user_services.dart';
import 'package:fitxkonnect/utils/colors.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/rating_bar.dart';
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
  String _searchedPlayer1Id = "";
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
            length: 2,
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
                    Tab(icon: Icon(Icons.games), text: 'UpComing Games'),
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
                  FutureBuilder(
                      future: MatchServices().getUserToComeMatches(
                          FirebaseAuth.instance.currentUser!.uid),
                      initialData: [],
                      builder: (context, snapshot) {
                        return createMatchesListView(context, snapshot);
                      }),
                  FutureBuilder(
                      future: MatchServices().getUserEndedMatches(
                          FirebaseAuth.instance.currentUser!.uid),
                      initialData: [],
                      builder: (context, snapshot) {
                        return createMatchesListView(context, snapshot);
                      }),
                ],
              ),
            ),
          ),
          Positioned(
            top: 700,
            right: 20,
            child: Material(
              color: Colors.white,
              child: Center(
                child: Ink(
                  decoration: const ShapeDecoration(
                    color: Colors.lightBlue,
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

  Widget buildPage(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 28, color: kPrimaryColor),
        ),
      );

  Future<UserModel> getUser() async {
    _userData = await UserServices().getSpecificUser(_searchedPlayer1Id);
    // setState(() {});
    return _userData;
  }

  Widget createMatchesListView(BuildContext context, AsyncSnapshot snapshot) {
    var values = snapshot.data;
    print("NUMERO DE MATCHES: ${values.length}");
    return values.length == 0
        ? Text(
            'No matches yet!',
            style: TextStyle(color: kPrimaryColor),
          )
        : ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: values.length,
            itemBuilder: (BuildContext context, int index) {
              _searchedPlayer1Id = values[index].player1;
              return values.isNotEmpty
                  ? FutureBuilder(
                      future: getUser(),
                      builder: (BuildContext context,
                          AsyncSnapshot<UserModel> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(16),
                                height: 180,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  gradient: LinearGradient(
                                      colors: [
                                        Color(0xff6DC8F3),
                                        Color(0xff73A1F9)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(255, 208, 85, 112),
                                      blurRadius: 12,
                                      offset: Offset(0, 6),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                top: 0,
                                child: CustomPaint(
                                  size: Size(120, 250),
                                  painter: CustomCardShapePainter(
                                      20, Color(0xff6DC8F3), Color(0xff73A1F9)),
                                ),
                              ),
                              Positioned.fill(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: Image.network(
                                          snapshot.data!.profilePhoto,
                                          height: 68,
                                          width: 68,
                                          fit: BoxFit.cover),
                                      flex: 2,
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            snapshot.data!.fullName,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Avenir',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18),
                                          ),
                                          Text(
                                            '${values[index].sport} · Casual ·',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Avenir',
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.lock_clock,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  values[index].startingTime,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Avenir',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  snapshot.data!.age,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Avenir',
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              Flexible(
                                                child: Text(
                                                  snapshot.data!.country
                                                      .substring(2),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Avenir',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            values[index].difficulty,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Avenir',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          RatingBar(rating: 3),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 20,
                                child: Center(
                                  child: Ink(
                                    decoration: const ShapeDecoration(
                                      color: Colors.lightBlue,
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
                            ],
                          ),
                        );
                      })
                  : CircularProgressIndicator();
            },
          );
  }
}

class CustomCardShapePainter extends CustomPainter {
  final double radius;
  final Color startColor;
  final Color endColor;

  CustomCardShapePainter(this.radius, this.startColor, this.endColor);

  @override
  void paint(Canvas canvas, Size size) {
    var radius = 24.0;

    var paint = Paint();
    paint.shader = ui.Gradient.linear(
        Offset(0, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(startColor).withLightness(0.8).toColor(),
      endColor
    ]);

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
