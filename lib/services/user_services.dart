import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/services/storage_methods.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/utils.dart';

class UserServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel> getSpecificUser(String userId) async {
    var result = await _firestore.collection('users').doc(userId).get();
    UserModel searchedUser = UserModel.fromSnap(result);
    return searchedUser;
  }

  Future<List<String>> getListOfUsersUIDS() async {
    var ref = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('name', descending: false)
        .get();
    List<DocumentSnapshot> usersList = ref.docs;
    List<UserModel> users = [];
    List<String> my_list = [];

    usersList.forEach((DocumentSnapshot snap) {
      users.add(UserModel.fromSnap(snap));
    });

    users.forEach((element) {
      my_list.add(element.uid);
    });

    return my_list;
  }

  Future<String> updateUser(
      String userId,
      User user,
      String fullName,
      String email,
      String actualEmail,
      String pass,
      String country,
      Uint8List file,
      bool modifyPicture) async {
    int counter = 0;
    String result = "success";

    try {
      if (pass.isEmpty) {
        result = "Please enter your password!";
      } else if (email != actualEmail && pass.isEmpty) {
        result = "Please enter your password in order to change the email";
      } else if (!regExp.hasMatch(email)) {
        result = 'Email format is not valid!';
      } else {
        await _firestore.collection('users').doc(userId).update({
          'fullName': fullName,
          'email': email,
          'country': country,
        });

        if (modifyPicture == true) {
          await StorageMethods().uploadImageToStorage('profilePics', file);
        }

        if (counter % 2 == 0 && email != actualEmail) {
          counter++;
          await user.updateEmail(email);
          UserCredential result = await user
              .reauthenticateWithCredential(EmailAuthProvider.credential(
            email: email,
            password: pass,
          ));
        } else {
          result = "Log in again in order to change the email!";
        }
      }
    } catch (error) {
      result = error.toString();
    }
    return result;
  }
}
