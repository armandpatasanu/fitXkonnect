import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/providers/user_provider.dart';
import 'package:fitxkonnect/screens/edit_profile.dart';
import 'package:fitxkonnect/screens/login_screen.dart';
import 'package:fitxkonnect/screens/my_matches_page.dart';
import 'package:fitxkonnect/services/auth_methods.dart';
import 'package:fitxkonnect/services/user_services.dart';
import 'package:fitxkonnect/utils/components/profile_page/profile_menu.dart';
import 'package:fitxkonnect/utils/components/profile_page/profile_pic.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/widgets/navi_bar.dart';
import 'package:fitxkonnect/utils/widgets/notifications_page.dart';
import 'package:fitxkonnect/utils/widgets/profile_sport_icon.dart';
import 'package:fitxkonnect/utils/widgets/search_screen/location_info.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const double PIN_VISIBLE_POSITION = 20;
const double PIN_INVISIBLE_POSITION = -220;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late double pinPillPosition = PIN_INVISIBLE_POSITION;
  bool isEditVisible = false;
  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      super.initState();
    }

    return FutureBuilder(
        future: UserServices()
            .getSpecificUser(FirebaseAuth.instance.currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<UserModel> user) {
          if (user.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Stack(children: [
            Scaffold(
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
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => NotificationsPage()));
                    },
                    icon: Icon(
                      Icons.notifications,
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
                    ProfilePic(profilePhoto: user.data!.profilePhoto),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${user.data!.fullName}, ${user.data!.age}',
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
                      user.data!.country,
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
                    Text(user.data!.email,
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
                      text: "Add Sport",
                      icon: Icon(Icons.search),
                      press: () => {},
                    ),
                    ProfileMenu(
                      text: "Edit Profile",
                      icon: Icon(Icons.settings),
                      press: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => FutureBuilder(
                                future: UserServices().getSpecificUser(
                                    FirebaseAuth.instance.currentUser!.uid),
                                builder: (BuildContext context,
                                    AsyncSnapshot<UserModel> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return EditProfilePage(snap: snapshot.data!);
                                })));
                      },
                    ),
                    ProfileMenu(
                      text: "My Matches",
                      icon: Icon(Icons.question_mark),
                      press: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => MyMatchesPage(
                                  user: user.data!,
                                )));
                      },
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: NaviBar(
                index: 3,
              ),
            ),
          ]);
        });
  }
}
