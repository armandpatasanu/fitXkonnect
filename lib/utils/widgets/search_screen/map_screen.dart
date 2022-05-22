import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitxkonnect/blocs/app_bloc.dart';
import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/services/location_services.dart';
import 'package:fitxkonnect/services/storage_methods.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/widgets/search_screen/location_info.dart';
import 'package:fitxkonnect/utils/widgets/search_screen/map_user_container.dart';
import 'package:fitxkonnect/utils/widgets/text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

const LatLng SOURCE_LOCATION = LatLng(45.7344183, 21.2330665);
const LatLng DEST_LOCATION = LatLng(45.7399665, 21.2355297);
const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const double PIN_VISIBLE_POSITION = 20;
const double PIN_INVISIBLE_POSITION = -220;

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  late AppBloc _applicationBloc;
  late Uint8List sourceIcon;
  late BitmapDescriptor destinationIcon;
  late LatLng destinationLocation;
  late double pinPillPosition = PIN_INVISIBLE_POSITION;
  final TextEditingController _locationController = TextEditingController();
  var locationData = {};
  LocationModel _selectedLocation = StorageMethods().getEmptyLocation();

  Set<Marker> _markers = Set<Marker>();

  @override
  void initState() {
    _applicationBloc = Provider.of<AppBloc>(context, listen: false);
    setSourceAndDestinationMarkerIcons();

    super.initState();
  }

  @override
  void dispose() {
    // _applicationBloc.dispose();
    super.dispose();
  }

  void setSourceAndDestinationMarkerIcons() async {
    sourceIcon = await getBytesFromAsset('assets/images/pin.png', 300);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  changeMapMode() {
    getJsonFile("assets/light.json").then(setMapStyle);
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    _mapController.setMapStyle(mapStyle);
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<AppBloc>(context);
    return Scaffold(
      body: (applicationBloc.currentLocation == null)
          ? Stack(children: [
              Container(
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new ExactAssetImage('assets/images/wtf.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: new BackdropFilter(
                  filter: new ui.ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                  child: new Container(
                    decoration:
                        new BoxDecoration(color: Colors.white.withOpacity(0.3)),
                  ),
                ),
              ),
              Center(child: CircularProgressIndicator(color: Colors.red)),
            ])
          : Stack(
              children: [
                GoogleMap(
                  myLocationEnabled: true,
                  zoomControlsEnabled: false,
                  compassEnabled: false,
                  mapToolbarEnabled: false,
                  zoomGesturesEnabled: true,
                  tiltGesturesEnabled: false,
                  markers: _markers,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(applicationBloc.currentLocation!.latitude,
                        applicationBloc.currentLocation!.longitude),
                    zoom: 14,
                  ),
                  onTap: (LatLng loc) {
                    setState(() {
                      pinPillPosition = PIN_INVISIBLE_POSITION;
                    });
                  },
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                    changeMapMode();
                    setState(() {
                      startQuery();
                    });
                  },
                ),
                // Container(
                //   color: Colors.white,
                //   child: TextButton.icon(
                //     //onPressed: handleMarkers,
                //     icon: Icon(Icons.sports_tennis),
                //     label: Text('Only this'),
                //   ),
                // ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      margin: EdgeInsets.only(top: 13, left: 15),
                      height: 40,
                      width: 210,
                      decoration: BoxDecoration(
                          // gradient: LinearGradient(
                          //   colors: [
                          //     Colors.white,
                          //     Color.fromRGBO(255, 188, 143, 1),
                          //   ],
                          //   begin: Alignment.centerLeft,
                          //   end: Alignment.centerRight,
                          // ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          border: Border.all(color: Colors.grey.shade300),
                          color: Colors.white.withOpacity(0.85),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: Offset(0, 1),
                            )
                          ]),
                      child: Container(
                        height: 30,
                        width: 50,
                        child: Row(
                          children: [
                            Icon(Icons.search, color: kPrimaryLightColor),
                            Flexible(
                              child: TextFormField(
                                controller: _locationController,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                                cursorColor: kPrimaryColor,
                                decoration: InputDecoration(
                                    hintText: 'Search in Timișoara',
                                    hintStyle: const TextStyle(
                                      fontFamily: "Netflix",
                                      fontSize: 15,
                                      letterSpacing: 0.0,
                                      color: Colors.grey,
                                    ),
                                    border: InputBorder.none),
                              ),
                            ),
                            Icon(Icons.filter_list,
                                color: kPrimaryLightColor, size: 25)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 10),
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                          // gradient: LinearGradient(
                          //   colors: [
                          //     Colors.white,
                          //     Color.fromRGBO(255, 188, 143, 1),
                          //   ],
                          //   begin: Alignment.centerLeft,
                          //   end: Alignment.centerRight,
                          // ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          border: Border.all(color: Colors.grey.shade300),
                          color: Colors.white.withOpacity(0.85),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: Offset(0, 1),
                            )
                          ]),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.format_list_bulleted,
                                size: 25,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'LIST',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: "Netflix",
                                  // fontWeight: FontWeight.w600,
                                  fontWeight: ui.FontWeight.bold,
                                  fontSize: 15,
                                  letterSpacing: 0.0,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  left: 0,
                  right: 0,
                  bottom: pinPillPosition,
                  child: LocationInfo(
                    selectedLocation: _selectedLocation,
                  ),
                ),
              ],
            ),
    );
  }

  // handleMarkers() {
  //   _markers.forEach((element) async {
  //     LocationModel location = LocationModel.fromSnap(await FirebaseFirestore
  //         .instance
  //         .collection('locations')
  //         .where('')
  //         .get());
  //     if()
  //   });
  // }

  startQuery() async {
    var ref = await FirebaseFirestore.instance.collection('locations').get();
    getMarkers(ref.docs);
  }

  void getMarkers(List<DocumentSnapshot> documentList) {
    documentList.forEach((DocumentSnapshot snap) {
      LocationModel location = LocationModel.fromSnap(snap);
      GeoPoint geoPoint = location.geopoint;
      setState(() {
        _markers.add(
          Marker(
              markerId: MarkerId(location.locationId),
              position: LatLng(geoPoint.latitude, geoPoint.longitude),
              icon: BitmapDescriptor.fromBytes(sourceIcon),
              infoWindow: InfoWindow(title: location.name),
              onTap: () {
                setState(() {
                  _selectedLocation = location;
                  pinPillPosition = PIN_VISIBLE_POSITION;
                });
              }),
        );
      });
    });
  }
}
