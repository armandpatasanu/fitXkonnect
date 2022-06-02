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

  const SpecialMatchCard({
    Key? key,
    this.snap,
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
      decoration: BoxDecoration(color: kPrimaryColor),
      height: 250,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Stack(
        children: [
          Container(
            height: 200,
            margin: EdgeInsets.only(left: 40, right: 40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: kPrimaryLightColor,
              image: DecorationImage(
                  colorFilter: new ColorFilter.mode(
                      Colors.black.withOpacity(0.2), BlendMode.dstATop),
                  image: NetworkImage(
                    'https://jooinn.com/images/sunny-day-1.jpg',
                  ),
                  fit: BoxFit.cover),
            ),
          ),
          Positioned(
            left: 100,
            child: Container(
              padding: EdgeInsets.only(left: 40, top: 30),
              child: Column(
                children: [
                  IconAndTextWidget(
                    icon: Icons.location_on,
                    text: widget.snap.locationName,
                    iconColor: kPrimaryColor,
                    color: kPrimaryColor,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  IconAndTextWidget(
                    icon: Icons.calendar_month,
                    text: widget.snap.matchDate,
                    iconColor: kPrimaryColor,
                    color: kPrimaryColor,
                  ),
                  SizedBox(
                    height: 15,
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
              height: 200,
              width: 200,
              margin: EdgeInsets.only(left: 40, right: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: kPrimaryLightColor,
              ),
            ),
          ),
          widget.snap.p1uid == FirebaseAuth.instance.currentUser!.uid
              ? Positioned(
                  left: 250,
                  top: 180,
                  child: Container(
                    width: 80,
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
                      },
                    ),
                  ),
                )
              : Positioned(
                  left: 250,
                  top: 180,
                  child: Container(
                    width: 80,
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
                top: 140,
                child: Container(
                  height: 100,
                  width: 220,
                  margin: EdgeInsets.only(left: 15, right: 20, bottom: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color.fromARGB(255, 198, 171, 171),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                    child: Column(
                      children: [
                        Text(
                          widget.snap.p1Name + ', ' + widget.snap.p1Age,
                          style: TextStyle(fontSize: 18, color: kPrimaryColor),
                        ),
                        SizedBox(
                          height: 0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Sport: ',
                                  style: TextStyle(color: kPrimaryColor),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                IconAndTextWidget(
                                  icon: Icons.sports_tennis,
                                  text: widget.snap.sport,
                                  color: Colors.white,
                                  iconColor: Colors.yellow,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                // Text(
                                //   locationData.contact.length > 0
                                //       ? locationData.contact[0]
                                //       : 'xxx',
                                //   style: TextStyle(color: kPrimaryColor),
                                // ),
                                FittedBox(
                                  child: Text('Difficulty:'),
                                  fit: BoxFit.fitWidth,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                IconAndTextWidget(
                                  icon: Icons.question_answer,
                                  text: widget.snap.difficulty,
                                  color: Colors.white,
                                  iconColor: Colors.yellow,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 30,
                left: 50,
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
