import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitxkonnect/blocs/app_bloc.dart';
import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/models/sport_model.dart';
import 'package:fitxkonnect/screens/location_filter_screen.dart';
import 'package:fitxkonnect/services/location_services.dart';
import 'package:fitxkonnect/services/sport_services.dart';
import 'package:fitxkonnect/services/storage_methods.dart';
import 'package:fitxkonnect/utils/colors.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/utils.dart';
import 'package:fitxkonnect/utils/widgets/navi_bar.dart';
import 'package:fitxkonnect/utils/widgets/search_screen/location_info.dart';
import 'package:fitxkonnect/utils/widgets/search_screen/map_user_container.dart';
import 'package:fitxkonnect/utils/widgets/text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

const LatLng SOURCE_LOCATION = LatLng(45.7344183, 21.2330665);
const LatLng DEST_LOCATION = LatLng(45.7399665, 21.2355297);
const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const double PIN_VISIBLE_POSITION = 20;
const double PIN_INVISIBLE_POSITION = -920;

class MapScreen extends StatefulWidget {
  final List<Map<LocationModel, List<String>>> loc_maps;
  final String filteredSport;
  final List<SportModel> listOfSports;
  MapScreen(
      {Key? key,
      required this.filteredSport,
      required this.listOfSports,
      required this.loc_maps})
      : super(key: key);

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
  List<LocationModel> _locationsToPass = [];
  List<SportModel> _sportsToPass = [];
  String sportName = '';
  Set<Marker> _markers = Set<Marker>();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

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
    sourceIcon =
        await getBytesFromAsset('assets/images/map_screen/pin.png', 300);
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

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.blue,
        points: polylineCoordinates,
        width: 3);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline(Position myPos) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyAqe-WSpShain2e78IdFL5FVvfv0oFfp7o',
        PointLatLng(myPos.latitude, myPos.longitude),
        PointLatLng(widget.loc_maps[0].keys.first.geopoint.latitude,
            widget.loc_maps[0].keys.first.geopoint.longitude),
        travelMode: TravelMode.driving);
    // wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")]);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<AppBloc>(context);
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // ),
      bottomNavigationBar: NaviBar(index: 1),
      body: Container(
        padding: EdgeInsets.only(top: 24),
        child: (applicationBloc.currentLocation == null)
            ? Stack(children: [
                Container(
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: new ExactAssetImage(
                          'assets/images/map_screen/loading_map.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: new BackdropFilter(
                    filter: new ui.ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                    child: new Container(
                      decoration: new BoxDecoration(
                          color: Colors.white.withOpacity(0.3)),
                    ),
                  ),
                ),
                Center(child: CircularProgressIndicator(color: Colors.red)),
              ])
            : Stack(
                children: [
                  GoogleMap(
                    polylines: Set<Polyline>.of(polylines.values),
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
                      widget.loc_maps.length == 1
                          ? _getPolyline(applicationBloc.currentLocation!)
                          : null;
                      _mapController = controller;
                      changeMapMode();
                      setState(() {
                        startQuery(applicationBloc.currentLocation!);
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
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                    Navigator.of(context).pushReplacement(
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (context, animation1, animation2) =>
                                                FilterLocationScreen(
                                          map_loc: widget.loc_maps,
                                          sports: _sportsToPass,
                                        ),
                                        transitionDuration: Duration(),
                                      ),
                                    );
                                  },
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
                              InkWell(
                                child: Icon(Icons.filter_list,
                                    color: kPrimaryLightColor, size: 25),
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation1,
                                              animation2) =>
                                          FutureBuilder<
                                                  List<
                                                      Map<LocationModel,
                                                          List<String>>>>(
                                              future: LocationServices()
                                                  .getMapOfLocationsBasedOfASport(
                                                sportName == ""
                                                    ? "LIST"
                                                    : sportName,
                                              ),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<
                                                          List<
                                                              Map<
                                                                  LocationModel,
                                                                  List<
                                                                      String>>>>
                                                      snapshot) {
                                                if (snapshot.connectionState ==
                                                        ConnectionState
                                                            .waiting ||
                                                    !snapshot.hasData) {
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                }
                                                return MapScreen(
                                                    loc_maps: snapshot.data!,
                                                    filteredSport:
                                                        sportName == ""
                                                            ? "LIST"
                                                            : sportName,
                                                    listOfSports:
                                                        widget.listOfSports);
                                              }),
                                      transitionDuration: Duration(),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 13, left: 10),
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
                          child: Container(
                            child: PopupMenuButton<String>(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0))),
                              offset: Offset(48, 32),
                              itemBuilder: (context) {
                                return widget.listOfSports.map((str) {
                                  return PopupMenuItem(
                                    value: str.name,
                                    child: Row(
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.center,
                                      children: [
                                        convertSportToIcon(str.name,
                                            widget.filteredSport, Colors.grey),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          str.name,
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }).toList();
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(
                                    Icons.format_list_bulleted,
                                    size: 25,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  convertSportToIcon(
                                    // sportName != widget.filteredSport ? sportName : widget.filteredSport,
                                    widget.filteredSport,
                                    widget.filteredSport,
                                    Colors.grey,
                                  ),
                                  // Text(
                                  //   widget.filteredSport,
                                  //   textAlign: TextAlign.left,
                                  //   style: TextStyle(
                                  //     fontFamily: "Netflix",
                                  //     // fontWeight: FontWeight.w600,
                                  //     fontWeight: ui.FontWeight.bold,
                                  //     fontSize: 15,
                                  //     letterSpacing: 0.0,
                                  //     color: Colors.black,
                                  //   ),
                                  // ),
                                ],
                              ),
                              onSelected: (v) {
                                setState(() {
                                  sportName = v;
                                });
                              },
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
      ),
    );
  }

  startQuery(Position myPos) async {
    _sportsToPass = await SportServices().getListOfSports();
    getMarkers(myPos, widget.loc_maps);
  }

  void getMarkers(
      Position myPos, List<Map<LocationModel, List<String>>> documentList) {
    documentList.forEach((Map<LocationModel, List<String>> location) {
      _locationsToPass.add(location.keys.first);
      GeoPoint geoPoint = location.keys.first.geopoint;
      // double distance = Geolocator.distanceBetween(myPos.longitude,
      //         myPos.latitude, geoPoint.longitude, geoPoint.latitude) /
      //     1000;
      String distance = (Geolocator.distanceBetween(myPos.longitude,
                  myPos.latitude, geoPoint.longitude, geoPoint.latitude) /
              1000)
          .toString()
          .substring(0, 4);
      LocationServices()
          .updateDistance(location.keys.first.locationId, distance);
      setState(() {
        _markers.add(
          Marker(
              markerId: MarkerId(location.keys.first.locationId),
              position: LatLng(geoPoint.latitude, geoPoint.longitude),
              icon: BitmapDescriptor.fromBytes(sourceIcon),
              infoWindow: InfoWindow(title: location.keys.first.name),
              onTap: () {
                setState(() {
                  _selectedLocation = location.keys.first;
                  pinPillPosition = PIN_VISIBLE_POSITION;
                });
              }),
        );
      });
    });
  }
}
