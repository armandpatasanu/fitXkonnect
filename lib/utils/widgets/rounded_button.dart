import 'package:fitxkonnect/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton(
      {Key? key,
      this.press,
      this.textColor = kPrimaryColor,
      required this.text,
      required this.isLoading})
      : super(key: key);
  final String text;
  final Function()? press;
  final Color? textColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: newElevatedButton(isLoading),
      ),
    );
  }

  Widget newElevatedButton(bool isLoading) {
    return ElevatedButton(
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : Text(
              text,
            ),
      onPressed: press,
      style: ElevatedButton.styleFrom(
          primary: kPrimaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          textStyle: TextStyle(
              letterSpacing: 2,
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans')),
    );
  }
}
