import 'dart:async';

import 'package:fitxkonnect/blocs/app_bloc.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/widgets/location_info.dart';
import 'package:fitxkonnect/utils/widgets/map_user_container.dart';
import 'package:flutter/material.dart';
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
  final Completer<GoogleMapController> _mapController = Completer();
  late final AppBloc applicationBloc;
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;
  late LatLng destinationLocation;
  late double pinPillPosition = PIN_INVISIBLE_POSITION;

  Set<Marker> _markers = Set<Marker>();

  @override
  void initState() {
    final applicationBloc = Provider.of<AppBloc>(context, listen: false);
    setSourceAndDestinationMarkerIcons();

    super.initState();
  }

  @override
  void dispose() {
    applicationBloc.dispose();

    super.dispose();
  }

  void setSourceAndDestinationMarkerIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2), "assets/images/pin.png");

    // destinationIcon = await BitmapDescriptor.fromAssetImage(
    //     ImageConfiguration(devicePixelRatio: 2.0),
    //     'assets/imgs/destination_pin_${parentCat}${Utils.deviceSuffix(context)}.png');
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<AppBloc>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: Text('Navigate'),
        centerTitle: true,
      ),
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
                    compassEnabled: false,
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
                      _mapController.complete(controller);
                      showPinsOnMap();
                    },
                  ),
                ),
                Positioned(
                  top: 0,
                  left: -20,
                  right: 30,
                  child: MapUserBadge(),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  left: 0,
                  right: 0,
                  bottom: pinPillPosition,
                  child: LocationInfo(),
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

  void showPinsOnMap() {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: SOURCE_LOCATION,
          icon: sourceIcon,
          onTap: () {
            setState(() {
              pinPillPosition = PIN_VISIBLE_POSITION;
            });
          }));

      _markers.add(
        Marker(
          markerId: MarkerId('destinationPin'),
          position: DEST_LOCATION,
          icon: sourceIcon,
        ),
      );
    });
  }
}
