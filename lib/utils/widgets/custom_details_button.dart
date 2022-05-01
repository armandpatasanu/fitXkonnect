import 'package:animations/animations.dart';
import 'package:fitxkonnect/screens/details_page.dart';
import 'package:fitxkonnect/screens/show_details_page.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomDetailsButton extends StatelessWidget {
  final String selectedLocation;
  const CustomDetailsButton({Key? key, required this.selectedLocation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("In custom DETAILS BUTTON THE ID IS: ${selectedLocation}");
    return OpenContainer(
      transitionDuration: Duration(seconds: 2),
      openBuilder: (context, _) => DetailPage(
        locationId: selectedLocation,
      ),
      closedShape: CircleBorder(),
      closedColor: Colors.white,
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
