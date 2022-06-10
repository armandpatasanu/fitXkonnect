import 'package:animations/animations.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitxkonnect/screens/details_page.dart';
import 'package:fitxkonnect/services/location_services.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomDetailsButton extends StatefulWidget {
  final String selectedLocation;
  const CustomDetailsButton({Key? key, required this.selectedLocation})
      : super(key: key);

  @override
  State<CustomDetailsButton> createState() => _CustomDetailsButtonState();
}

class _CustomDetailsButtonState extends State<CustomDetailsButton> {
  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionDuration: Duration(seconds: 2),
      openBuilder: (context, _) => FutureBuilder(
          future: Future.wait([
            FirebaseStorage.instance
                .ref()
                .child(
                    "locationPics/backgroundPics/${widget.selectedLocation}.jpg")
                .getDownloadURL(),
            FirebaseStorage.instance
                .ref()
                .child(
                    "locationPics/profilePics/${widget.selectedLocation}.jpg")
                .getDownloadURL(),
            LocationServices().getCertainLocation(widget.selectedLocation),
          ]),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return DetailPage(
              backIcon: false,
              bkg: snapshot.data![0],
              profile: snapshot.data![1],
              location: snapshot.data![2],
              map_loc: [],
              sports: [],
              locationId: widget.selectedLocation,
            );
          }),
      closedShape: CircleBorder(),
      // closedColor: Colors.white,
      closedBuilder: (context, openContainer) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: kPrimaryLightColor,
        ),
        height: 56,
        width: 56,
        child: Icon(Icons.remove_red_eye, color: Colors.white),
      ),
    );
  }
}
