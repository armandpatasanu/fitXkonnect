import 'dart:typed_data';

import 'package:gender_picker/source/enums.dart';

class AuthMethods {
  RegExp regExp = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );

  Future<String> registerValidation({
    required String email,
    required String password,
    required String username,
    required Uint8List? file,
    required Gender? gender,
    required String? country,
  }) async {
    String result = 'success';
    try {
      if (email.isEmpty) {
        result = 'Email field cannot be empty!';
      } else if (!regExp.hasMatch(email)) {
        result = 'Email format is not valid!';
      } else if (password.isEmpty) {
        result = 'Password field cannot be empty!';
      } else if (password.length < 6) {
        result = 'Password length too short!';
      } else if (country == null) {
        result = 'Please select your country!';
      }
    } catch (error) {
      result = error.toString();
    }
    return result;
  }
}
