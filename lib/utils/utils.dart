import 'dart:typed_data';

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
