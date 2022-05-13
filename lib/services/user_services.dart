import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/services/storage_methods.dart';

class UserServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getSpecificUser(String userId) async {
    var result = await _firestore.collection('users').doc(userId).get();

    UserModel searchedUser = UserModel.fromSnap(result);
    return searchedUser;
  }

  Future updateUser(
      String userId, String fullName, String email, String country) async {
    var result = await _firestore.collection('users').doc(userId).update({
      'fullName': fullName,
      'email': email,
      'country': country,
    });

    // String photoUrl =
    //     await StorageMethods().uploadImageToStorage('profilePics', file);
  }
}
