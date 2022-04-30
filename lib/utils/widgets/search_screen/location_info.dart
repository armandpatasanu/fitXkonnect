import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/services/storage_methods.dart';
import 'package:fitxkonnect/utils/colors.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationInfo extends StatefulWidget {
  // final String name;
  // final List<String> contact;
  final LocationModel selectedLocation;
  const LocationInfo({
    Key? key,
    required this.selectedLocation,
    // required this.contact,
    // required this.name,
  }) : super(key: key);

  @override
  State<LocationInfo> createState() => _LocationInfoState();
}

class _LocationInfoState extends State<LocationInfo> {
  String _imageUrl =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4c/Brad_Pitt_2019_by_Glenn_Francis.jpg/1200px-Brad_Pitt_2019_by_Glenn_Francis.jpg';
  var locationData = {};
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    print("I AM HERE");
    // if (widget.selectedLocation != null) {
    //   print("I cant GET HERE!");
    //   var ref = FirebaseStorage.instance.ref().child(
    //       "locationPics/backgroundPics/${widget.selectedLocation!.locationId}.jpg");
    //   ref.getDownloadURL().then((value) => setState(() => _imageUrl = value));
    // }
    // print("LOLOLOLOLOLOLOLOLOLOLOL@@@@@@@@@@ LOL " + photo);
    super.initState();
    print("FIRST INIT: ${widget.selectedLocation.locationId}");
    // getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var ref = FirebaseStorage.instance.ref().child(
          "locationPics/backgroundPics/${widget.selectedLocation.locationId}.jpg");

      ref.getDownloadURL().then((value) => setState(() => _imageUrl = value));

      setState(() {});
    } catch (e) {
      showSnackBar(
        e.toString(),
        context,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget build(BuildContext context) {
    getData();

    print(widget.selectedLocation.name);
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset.zero)
              ]),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ClipRect(
                          child: Image.network(_imageUrl,
                              width: 60, height: 60, fit: BoxFit.cover),
                        ),
                        // Positioned(
                        //   bottom: -10,
                        //   right: 0,
                        //   child: Icon(
                        //     Icons.directions,
                        //     color: kPrimaryColor,
                        //   ),
                        // )
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.selectedLocation.name,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.selectedLocation.contact.length > 0
                              ? widget.selectedLocation.contact[0]
                              : 'WTF',
                          style: TextStyle(
                              color: kPrimaryLightColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              Container(
                child: Row(
                  children: [
                    ClipRect(
                      child: Image.asset('assets/images/sportsGuys.jpg',
                          width: 60, height: 60, fit: BoxFit.cover),
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tenis, Fotbal, Squash',
                          style: TextStyle(
                              fontSize: 14,
                              color: kPrimaryLightColor,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Available matches: 4',
                          style: TextStyle(color: kPrimaryColor),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: 76,
          left: 280,
          child: Container(
            decoration: BoxDecoration(
                color: kPrimaryLightColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: kPrimaryColor.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 5,
                    offset: Offset(0, 4),
                  ),
                ]),
            child: TextButton(
              child: Text(
                'See Details',
                style: TextStyle(
                    fontFamily: 'OpenSans', fontWeight: FontWeight.bold),
              ),
              onPressed: () => {},
              style: TextButton.styleFrom(
                primary: kPrimaryColor,
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                backgroundColor: kPrimaryLightColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
