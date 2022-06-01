import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No Image Selected');
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
  ));
}

Future<Uint8List> getDefaultProfilePicture() async {
  Uint8List byteImage = await networkImageToByte(
    'https://spng.pngfind.com/pngs/s/110-1102775_download-empty-profile-hd-png-download.png',
  );
  return byteImage;
}

Widget convertSportToIcon(String sport, String text, Color color) {
  switch (sport) {
    case 'Badminton':
      return Image.asset(
        'assets/images/sport_icons/badminton.png',
        width: 25,
        height: 25,
        fit: BoxFit.cover,
        color: color,
      );

    case 'Biliard':
      return Image.asset(
        'assets/images/sport_icons/biliard.jpg',
        width: 25,
        height: 25,
        fit: BoxFit.cover,
        color: color,
      );
    case 'Darts':
      return Image.asset(
        'assets/images/sport_icons/darts.png',
        width: 25,
        height: 25,
        fit: BoxFit.cover,
        color: color,
      );
    case 'Golf':
      return Image.asset(
        'assets/images/sport_icons/golf.png',
        width: 25,
        height: 25,
        fit: BoxFit.cover,
        color: color,
      );
    case 'PadBol':
      return Image.asset(
        'assets/images/sport_icons/padbol.png',
        width: 25,
        height: 25,
        fit: BoxFit.cover,
        color: color,
      );
    case 'Squash':
      return Image.asset(
        'assets/images/sport_icons/squash.png',
        width: 25,
        height: 25,
        fit: BoxFit.cover,
        color: color,
      );
    case 'Tenis':
      return Image.asset(
        'assets/images/sport_icons/tenis.png',
        width: 25,
        height: 25,
        fit: BoxFit.cover,
        color: color,
      );
    case 'Tenis de masa':
      return Image.asset(
        'assets/images/sport_icons/tenis_de_masa.png',
        width: 25,
        height: 25,
        fit: BoxFit.cover,
        color: color,
      );
    default:
      return Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontFamily: "Netflix",
          // fontWeight: FontWeight.w600,
          fontWeight: ui.FontWeight.bold,
          fontSize: 15,
          letterSpacing: 0.0,
          color: Colors.black,
        ),
      );
  }
}
