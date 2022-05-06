import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/providers/user_provider.dart';
import 'package:fitxkonnect/screens/login_screen.dart';
import 'package:fitxkonnect/screens/my_matches.dart';
import 'package:fitxkonnect/services/auth_methods.dart';
import 'package:fitxkonnect/utils/components/profile_page/profile_menu.dart';
import 'package:fitxkonnect/utils/components/profile_page/profile_pic.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/widgets/profile_sport_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditVisible = false;
  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context).getUser();

    addData() async {
      UserProvider _userProvider = Provider.of(context, listen: false);
      await _userProvider.refreshUser();
    }

    @override
    void initState() {
      addData();
      super.initState();
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 1, 1, 1),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        toolbarHeight: 40,
        actions: [
          IconButton(
            onPressed: () async {
              await AuthMethods().logOutUser();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: ((context) => LoginScreen()),
                ),
              );
            },
            icon: Icon(
              Icons.logout_outlined,
            ),
          ),
        ],
        // title: Text(
        //   user.fullName,
        //   style: TextStyle(fontFamily: 'OpenSans', color: kPrimaryLightColor),
        // ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 30),
        child: Column(
          children: [
            ProfilePic(profilePhoto: user.profilePhoto),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      '${user.fullName}, ${user.age}',
                      style: TextStyle(
                        fontSize: 21,
                        color: kPrimaryLightColor,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              user.country,
              style: TextStyle(
                fontSize: 21,
                color: Colors.white,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Text(user.email,
                style: TextStyle(
                  color: kPrimaryLightColor,
                  fontSize: 14,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w600,
                )),
            SizedBox(height: 2),
            Container(
              margin: EdgeInsets.symmetric(vertical: 2, horizontal: 40),
              // alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Sports Played:',
                    style: TextStyle(
                      color: kPrimaryLightColor,
                      fontSize: 14,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  // Flexible(
                  //   child: ListView.builder(
                  //     itemCount: user.sports.length,
                  //     itemBuilder: (context, index) => SportIcon(
                  //       difficulty: user.sports[index]["difficulty"],
                  //       sport: user.sports[index]["sport"],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ProfileMenu(
              text: "My Profile",
              icon: Icon(Icons.search),
              press: () => {},
            ),
            ProfileMenu(
              text: "Edit Profile",
              icon: Icon(Icons.settings),
              press: () {
                setState(() {
                  setState(() {
                    isEditVisible = !isEditVisible;
                  });
                });
              },
            ),
            isEditVisible == true
                ? Container(
                    // duration: const Duration(milliseconds: 300),
                    // curve: Curves.easeInOut,
                    // left: -25,
                    // right: 25,
                    // top: 10,
                    child: Text('To be added edit'),
                  )
                : Container(
                    width: 0,
                    height: 0,
                  ),
            ProfileMenu(
              text: "My Matches",
              icon: Icon(Icons.question_mark),
              press: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MyMatches()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
