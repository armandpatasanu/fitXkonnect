import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/screens/show_details_page.dart';
import 'package:fitxkonnect/services/location_services.dart';
import 'package:fitxkonnect/services/match_services.dart';
import 'package:fitxkonnect/services/storage_methods.dart';
import 'package:fitxkonnect/utils/colors.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/utils.dart';
import 'package:fitxkonnect/utils/widgets/custom_details_button.dart';
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
  // String _imageUrl =
  //     'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4c/Brad_Pitt_2019_by_Glenn_Francis.jpg/1200px-Brad_Pitt_2019_by_Glenn_Francis.jpg';
  var locationData = {};
  bool isLoading = false;
  String _locationSports = "a";

  @override
  void initState() {
    super.initState();
  }

  Future<String> getLocationSports() async {
    return await LocationServices()
        .getLocationSports(widget.selectedLocation.locationId);
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          FirebaseStorage.instance
              .ref()
              .child(
                  "locationPics/backgroundPics/${widget.selectedLocation.locationId}.jpg")
              .getDownloadURL(),
          getLocationSports(),
          MatchServices().getNumberOfMatchesOpenBasedOnLocation(
              widget.selectedLocation.locationId),
        ]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
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
                          Flexible(
                            child: ClipRect(
                              child: Image.network(snapshot.data![0],
                                  width: 60, height: 60, fit: BoxFit.cover),
                            ),
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
                                snapshot.data![1] ?? '',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                snapshot.data![2] != 0
                                    ? 'Available matches: ${snapshot.data![2].toString()}'
                                    : 'No availabe matches ',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.normal),
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
                top: 90,
                left: 280,
                child: Container(
                  decoration: BoxDecoration(
                    // color: kPrimaryLightColor,
                    borderRadius: BorderRadius.circular(15),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: kPrimaryColor.withOpacity(0.2),
                    //     blurRadius: 2,
                    //     spreadRadius: 2,
                    //     offset: Offset(0, 2),
                    //   ),
                    // ],
                  ),
                  child: CustomDetailsButton(
                      selectedLocation: widget.selectedLocation.locationId),
                ),
              )
            ],
          );
        });
  }
}
