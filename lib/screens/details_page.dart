import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitxkonnect/models/dp_match_model.dart';
import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/models/match_model.dart';
import 'package:fitxkonnect/models/sport_model.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/screens/location_filter_screen.dart';
import 'package:fitxkonnect/services/location_services.dart';
import 'package:fitxkonnect/services/match_services.dart';
import 'package:fitxkonnect/services/storage_methods.dart';
import 'package:fitxkonnect/services/user_services.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:ui' as ui;

class DetailPage extends StatefulWidget {
  final bool backIcon;
  final String bkg;
  final String profile;
  final LocationModel location;
  final String locationId;
  final List<SportModel> sports;
  final List<Map<LocationModel, List<String>>> map_loc;
  const DetailPage({
    Key? key,
    required this.locationId,
    required this.sports,
    required this.map_loc,
    required this.bkg,
    required this.profile,
    required this.location,
    required this.backIcon,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryLightColor,
        title: widget.backIcon == true
            ? Row(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                FilterLocationScreen(
                              map_loc: widget.map_loc,
                              sports: widget.sports,
                            ),
                            transitionDuration: Duration(),
                          ),
                        );
                      },
                    ),
                  )
                ],
              )
            : Container(),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: size.height * 0.35,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(widget.bkg), fit: BoxFit.cover),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: size.height * 0.3),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(50)),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    child: Container(
                      width: 150,
                      height: 7,
                      decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(24)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                              image: NetworkImage(widget.profile),
                              fit: BoxFit.cover),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.location.name,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            widget.location.contact[0],
                            style:
                                TextStyle(fontSize: 13, color: kPrimaryColor),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "SCHEDULE",
                    style: TextStyle(
                        fontSize: 20, height: 1.5, color: kPrimaryColor),
                  ),
                  Text(
                    widget.location.schedule,
                    style: TextStyle(height: 1.6, color: kPrimaryColor),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "CONTACT",
                    style: TextStyle(
                        fontSize: 20, height: 1.5, color: kPrimaryColor),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_city,
                              color: kPrimaryLightColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.location.contact[0],
                              style: TextStyle(color: kPrimaryColor),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.phone,
                              color: kPrimaryLightColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.location.contact[1],
                              style: TextStyle(color: kPrimaryColor),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.web,
                              color: kPrimaryLightColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.location.contact[2],
                              style: TextStyle(color: kPrimaryColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "MATCHES",
                    style: TextStyle(fontSize: 18, color: kPrimaryColor),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 200,
                    child: FutureBuilder<List<DetailsPageMatch>>(
                        future: MatchServices()
                            .getActualDetailsPageMatches(widget.locationId),
                        initialData: [],
                        builder: (BuildContext context,
                            AsyncSnapshot<List<DetailsPageMatch>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return createMatchesListView(context, snapshot.data!);
                        }),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Widget createMatchesListView(
      BuildContext context, List<DetailsPageMatch> snapshot) {
    var values = snapshot;
    return values.length != 0
        ? PageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: values.length,
            itemBuilder: (BuildContext context, int index) {
              return values.isNotEmpty
                  ? Padding(
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
                              size: Size(150, 250),
                              painter: CustomCardShapePainter(
                                  20, Color(0xff6DC8F3), Color(0xff73A1F9)),
                            ),
                          ),
                          Positioned.fill(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Image.network(
                                    values[index].p1Profile,
                                    height: 88,
                                    width: 88,
                                  ),
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
                                        values[index].p1Name,
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
                                              values[index].p1Age,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Avenir',
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Flexible(
                                            child: Text(
                                              values[index]
                                                  .p1Country
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
                          values[index].p1uid ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? Positioned(
                                  left: 200,
                                  top: 120,
                                  child: Container(
                                    width: 85,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                        colors: <Color>[
                                          Colors.red,
                                          Colors.black
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(0.0, 1.5),
                                          blurRadius: 1.5,
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.cancel),
                                      onPressed: () async {
                                        await MatchServices()
                                            .cancelMatch(values[index].matchId);
                                        setState(() {});
                                        // widget.callbackFunction();
                                      },
                                    ),
                                  ),
                                )
                              : Positioned(
                                  left: 200,
                                  top: 120,
                                  child: Container(
                                    width: 85,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                        colors: <Color>[
                                          Colors.green,
                                          Colors.black
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(0.0, 1.5),
                                          blurRadius: 1.5,
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.play_circle),
                                      onPressed: () {
                                        MatchServices().matchPlayers(
                                            values[index].matchId,
                                            FirebaseAuth
                                                .instance.currentUser!.uid);
                                      },
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    )
                  : CircularProgressIndicator();
            },
          )
        : Text(
            'No matches are being played',
            style: TextStyle(color: kPrimaryColor),
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
