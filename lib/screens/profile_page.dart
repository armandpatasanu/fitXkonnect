import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/providers/user_provider.dart';
import 'package:fitxkonnect/screens/edit_profile.dart';
import 'package:fitxkonnect/screens/login_screen.dart';
import 'package:fitxkonnect/screens/my_matches_page.dart';
import 'package:fitxkonnect/services/auth_methods.dart';
import 'package:fitxkonnect/services/sport_services.dart';
import 'package:fitxkonnect/services/user_services.dart';
import 'package:fitxkonnect/utils/colors.dart';
import 'package:fitxkonnect/utils/components/profile_page/profile_menu.dart';
import 'package:fitxkonnect/utils/components/profile_page/profile_pic.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/utils.dart';
import 'package:fitxkonnect/utils/widgets/custom_details_button.dart';
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
  String? _sport;
  String? _difficulty;
  List<bool> _isSelected = List.generate(3, (index) => false);
  @override
  void addSport(String uid, String dif, String sport) {
    String result = "success";

    SportServices().addSport(uid, dif, sport);
    print("@@@@@@@@GOT HERE");
    showSnackBar("The sport has been added!", context);
  }

  Widget build(BuildContext context) {
    @override
    void initState() {
      super.initState();
    }

    return FutureBuilder(
        future: UserServices()
            .getSpecificUser(FirebaseAuth.instance.currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<UserModel> user) {
          if (user.connectionState == ConnectionState.waiting ||
              !user.hasData) {
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
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    ProfileMenu(
                      text: "Configure a sport",
                      icon: Icon(Icons.add),
                      press: () {
                        setState(() {
                          if (pinPillPosition == PIN_VISIBLE_POSITION)
                            pinPillPosition = PIN_INVISIBLE_POSITION;
                          else
                            pinPillPosition = PIN_VISIBLE_POSITION;
                        });
                      },
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
            AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                left: 0,
                right: 0,
                bottom: pinPillPosition,
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: Offset.zero)
                          ]),
                      child: Column(
                        children: [
                          Container(
                            color: Colors.white,
                            child: Material(
                                color: Colors.white,
                                child: Row(
                                  children: [
                                    buildSportsDropDown(),
                                    ToggleButtons(
                                      selectedColor: kPrimaryLightColor,
                                      selectedBorderColor: kPrimaryColor,
                                      children: <Widget>[
                                        Icon(Icons.ac_unit,
                                            color: kPrimaryColor),
                                        Icon(
                                          Icons.call,
                                          color: kPrimaryColor,
                                        ),
                                        Icon(Icons.cake, color: kPrimaryColor),
                                      ],
                                      onPressed: (int index) {
                                        print('HELOO $index');
                                        switch (index) {
                                          case 0:
                                            _difficulty = 'easy';
                                            break;
                                          case 1:
                                            _difficulty = 'medium';
                                            break;
                                          case 2:
                                            _difficulty = 'hard';
                                            break;
                                          default:
                                        }
                                        setState(() {
                                          for (int buttonIndex = 0;
                                              buttonIndex < _isSelected.length;
                                              buttonIndex++) {
                                            if (buttonIndex == index) {
                                              _isSelected[buttonIndex] = true;
                                            } else {
                                              _isSelected[buttonIndex] = false;
                                            }
                                          }
                                        });
                                      },
                                      isSelected: _isSelected,
                                    ),
                                  ],
                                )),
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton.icon(
                                  label: Text('Add'),
                                  icon: Icon(Icons.add_box),
                                  onPressed: () {
                                    addSport(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        _difficulty!,
                                        _sport!);
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )),
          ]);
        });
  }

  @override
  Widget buildSportsDropDown() {
    return FutureBuilder<List<String>>(
        future: SportServices()
            .getDifferentSports(FirebaseAuth.instance.currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (!snapshot.hasData) return Container();
          return DropdownButtonHideUnderline(
            child: DropdownButton2(
              isExpanded: true,
              hint: Row(
                children: const [
                  SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Text(
                      'Pick',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              items: snapshot.data!
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.star,
                                  size: 18,
                                  color: kPrimaryColor,
                                ),
                              ),
                              TextSpan(
                                  text: item,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
              value: _sport,
              onChanged: (value) {
                setState(() {
                  _sport = value as String;
                });
              },
              icon: const Icon(
                Icons.add,
              ),
              iconSize: 21,
              iconEnabledColor: Colors.black,
              buttonHeight: 50,
              buttonWidth: 150,
              buttonPadding: const EdgeInsets.only(left: 14, right: 14),
              buttonDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.black26,
                ),
                color: kPrimaryLightColor,
              ).copyWith(
                boxShadow: kElevationToShadow[2],
              ),
              itemHeight: 40,
              itemPadding: const EdgeInsets.only(left: 14, right: 14),
              dropdownMaxHeight: 200,
              dropdownPadding: null,
              scrollbarRadius: const Radius.circular(40),
              scrollbarThickness: 6,
              scrollbarAlwaysShow: true,
            ),
          );
        });
  }
}
