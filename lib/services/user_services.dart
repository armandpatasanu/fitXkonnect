import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/services/storage_methods.dart';

class UserServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getSpecificUser(String userId) async {
    print('ALOHA BOI1');
    var result = await _firestore.collection('users').doc(userId).get();
    print('ALOHA BOI2');
    UserModel searchedUser = UserModel.fromSnap(result);
    print('ALOHA BOI3');
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

  Future<String> updateUser(String userId, String fullName, String email,
      String country, Uint8List file, bool modifyPicture) async {
    String result = "success";
    // print("UHM?: $fullName");
    // print(email);
    // print(country);
    try {
      await _firestore.collection('users').doc(userId).update({
        'fullName': fullName,
        'email': email,
        'country': country,
      });
    } catch (error) {
      result = error.toString();
    }

    if (modifyPicture == true) {
      await StorageMethods().uploadImageToStorage('profilePics', file);
    }

    return result;
  }
}
