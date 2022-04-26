import 'package:flutter/material.dart';

import 'profile_menu.dart';
import 'profile_pic.dart';

class ProfileBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "My Profile",
            icon: Icon(Icons.search),
            press: () => {},
          ),
          ProfileMenu(
            text: "Notifications",
            icon: Icon(Icons.notifications),
            press: () {},
          ),
          ProfileMenu(
            text: "Edit Profile",
            icon: Icon(Icons.settings),
            press: () {},
          ),
          ProfileMenu(
            text: "My Matches",
            icon: Icon(Icons.question_mark),
            press: () {},
          ),
          ProfileMenu(
            text: "Log Out",
            icon: Icon(Icons.logout),
            press: () {},
          ),
        ],
      ),
    );
  }
}
