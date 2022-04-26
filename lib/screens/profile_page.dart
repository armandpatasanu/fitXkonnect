import 'package:fitxkonnect/utils/components/profile_body.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 1, 1, 1),
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text("My account"),
      ),
      body: ProfileBody(),
    );
  }
}
