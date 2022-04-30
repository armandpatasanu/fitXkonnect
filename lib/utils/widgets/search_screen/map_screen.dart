import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitxkonnect/blocs/app_bloc.dart';
import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/widgets/search_screen/location_info.dart';
import 'package:fitxkonnect/utils/widgets/search_screen/map_user_container.dart';
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
  var locationData = {};
  LocationModel _selectedLocation = LocationModel(
      locationId: '',
      contact: [],
      schedule: '',
      sports: [],
      name: '',
      geopoint: GeoPoint(0, 0));

  Set<Marker> _markers = Set<Marker>();

  @override
  void initState() {
    _applicationBloc = Provider.of<AppBloc>(context, listen: false);
    setSourceAndDestinationMarkerIcons();

    super.initState();
  }

  @override
  void dispose() {
    // _applicationBloc.dispose(); BUT HOW? Error AppBloc() still used after being disposed
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

    // LocationModel location = LocationModel(
    //     locationId: '',
    //     contact: [],
    //     schedule: '',
    //     sports: [],
    //     name: '',
    //     geopoint: GeoPoint(0, 0));
    // if (_selectedLocation != null) {
    //    location = _selectedLocation;
    // } else {
    //   print(
    //       "------------ After build this value is: ${_selectedLocation.name}");
    // }
    print("------------ After build this value is: ${_selectedLocation.name}");
    return Scaffold(
      body: (applicationBloc.currentLocation == null)
          ? Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            )
          : Stack(
              children: [
                Positioned.fill(
                  child: GoogleMap(
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
                      // showPinsOnMap();

                      setState(() {
                        startQuery();
                      });
                    },
                  ),
                ),
                // Positioned(
                //   top: 0,
                //   left: -20,
                //   right: 30,
                //   child: MapUserBadge(),
                // ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  left: 0,
                  right: 0,
                  bottom: pinPillPosition,
                  // top: 10,
                  child: LocationInfo(
                    selectedLocation: _selectedLocation,
                    // name: _selectedLocation!.name,
                    // contact: _selectedLocation!.contact,
                  ),
                ),
                // floatingActionButton: FloatingActionButton.extended(
                //   onPressed: () async {
                //     Position position = await GeolocatorService().getCurrentLocation();

                //     _goToPlace(LatLng(position.latitude, position.longitude));
                //     _markers.add(Marker(
                //         icon: await BitmapDescriptor.fromAssetImage(
                //             ImageConfiguration(devicePixelRatio: 2),
                //             "assets/images/home_location.png"),
                //         markerId: const MarkerId('currentLocation'),
                //         position: LatLng(position.latitude, position.longitude)));
                //     setState(() {});
                //   },
                //   label: const Text("Current Location"),
                //   icon: const Icon(Icons.location_history),
                // ),
              ],
            ),
    );
  }

  startQuery() async {
    var ref = await FirebaseFirestore.instance.collection('locations').get();
    getMarkers(ref.docs);
  }

  void getMarkers(List<DocumentSnapshot> documentList) {
    documentList.forEach((DocumentSnapshot snap) {
      LocationModel location = LocationModel.fromSnap(snap);
      GeoPoint geoPoint = location.geopoint;
      // print('############ ${location.name}');
      // print('@@@@@@@@@@@@ ${geoPoint.latitude}');
      setState(() {
        _markers.add(
          Marker(
              markerId: MarkerId(location.locationId),
              position: LatLng(geoPoint.latitude, geoPoint.longitude),
              icon: BitmapDescriptor.fromBytes(sourceIcon),
              infoWindow: InfoWindow(title: location.name),
              onTap: () {
                // print('############ ${_selectedLocation!.name}');
                // print(
                //     '@@@@@@@@@@@@@@@@@@@@@@@@@ ${_selectedLocation!.locationId}');
                setState(() {
                  _selectedLocation = location;
                  print('############ ${_selectedLocation.name}');
                  print(
                      '@@@@@@@@@@@@@@@@@@@@@@@@@ ${_selectedLocation.locationId}');
                  pinPillPosition = PIN_VISIBLE_POSITION;
                });
              }),
        );
      });
    });
  }

  void showPinsOnMap() {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: SOURCE_LOCATION,
          icon: BitmapDescriptor.fromBytes(sourceIcon),
          infoWindow: InfoWindow(title: 'Baza2'),
          onTap: () {
            setState(() {
              pinPillPosition = PIN_VISIBLE_POSITION;
            });
          }));

      _markers.add(
        Marker(
          markerId: MarkerId('destinationPin'),
          position: DEST_LOCATION,
          icon: BitmapDescriptor.fromBytes(sourceIcon),
        ),
      );
    });
  }
}
