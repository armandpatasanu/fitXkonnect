import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/services/location_services.dart';
import 'package:fitxkonnect/services/match_services.dart';
import 'package:fitxkonnect/services/storage_methods.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/utils.dart';
import 'package:fitxkonnect/utils/widgets/icon_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class SpecialMatchCard extends StatefulWidget {
  final snap;
  final Function callbackFunction;

  SpecialMatchCard({
    Key? key,
    this.snap,
    required this.callbackFunction,
  }) : super(key: key);

  @override
  State<SpecialMatchCard> createState() => _SpecialMatchCardState();
}

class _SpecialMatchCardState extends State<SpecialMatchCard> {
  UserModel userData = StorageMethods().getEmptyUser();
  LocationModel locationData = StorageMethods().getEmptyLocation();
  bool isLoading = false;
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      height: 250,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Container(
            height: 200,
            margin: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
              image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.8), BlendMode.dstATop),
                image: new ExactAssetImage(
                    'assets/images/period_images/night.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            left: 190,
            top: 30,
            child: Container(
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Column(
                children: [
                  IconAndTextWidget(
                    icon: Icons.location_on,
                    text: widget.snap.locationName,
                    iconColor: kPrimaryColor,
                    color: kPrimaryColor,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  IconAndTextWidget(
                    icon: Icons.calendar_month,
                    text: widget.snap.matchDate,
                    iconColor: kPrimaryColor,
                    color: kPrimaryColor,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  IconAndTextWidget(
                    icon: Icons.access_alarm,
                    text: widget.snap.startingTime,
                    iconColor: kPrimaryColor,
                    color: kPrimaryColor,
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.center,
              ),

              width: 200,
              // margin: EdgeInsets.only(left: 40, right: 40),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30), color: Colors.white),
            ),
          ),
          widget.snap.p1uid == FirebaseAuth.instance.currentUser!.uid
              ? Positioned(
                  left: 260,
                  top: 140,
                  child: Container(
                    width: 85,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: <Color>[Colors.red, Colors.black],
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
                      onPressed: () {
                        MatchServices().cancelMatch(widget.snap.matchId);
                        setState(() {});
                        widget.callbackFunction(widget.snap.locationName);
                      },
                    ),
                  ),
                )
              : Positioned(
                  left: 260,
                  top: 140,
                  child: Container(
                    width: 85,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: <Color>[Colors.green, Colors.black],
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
                        MatchServices().matchPlayers(widget.snap.matchId,
                            FirebaseAuth.instance.currentUser!.uid);
                      },
                    ),
                  ),
                ),
          Stack(
            children: [
              Container(
                height: 250,
              ),
              Positioned(
                top: 132,
                left: 5,
                child: Container(
                  height: 70,
                  width: 210,
                  margin: EdgeInsets.only(left: 15, right: 20, bottom: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: Container(
                    padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                    child: Column(children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.snap.p1Name + ', ' + widget.snap.p1Age,
                        style: TextStyle(fontSize: 18, color: kPrimaryColor),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                          height: 25,
                          width: 160,
                          child: Row(
                            children: [
                              Text(
                                widget.snap.sport,
                                style: TextStyle(color: kPrimaryColor),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              convertSportToIcon(
                                  widget.snap.sport, '', Colors.black),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                ' -  ${widget.snap.difficulty}',
                                style: TextStyle(color: kPrimaryColor),
                              ),
                              // IconAndTextWidget(
                              //   icon: Icons.sports_tennis,
                              //   text: widget.snap.sport,
                              //   color: Colors.white,
                              //   iconColor: Colors.yellow,
                              // ),
                            ],
                          )),
                    ]),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                left: 65,
                child: Container(
                    width: 120.0,
                    height: 120.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.cover,
                            image: new NetworkImage(widget.snap.p1Profile)))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
