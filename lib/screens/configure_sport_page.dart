import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/services/sport_services.dart';
import 'package:fitxkonnect/utils/components/profile_page/profile_pic.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/utils.dart';
import 'package:fitxkonnect/utils/widgets/navi_bar.dart';
import 'package:flutter/material.dart';

class ConfigureSportPage extends StatefulWidget {
  final List<String> not_conf_sports;
  final List<String> conf_sports;
  final UserModel user;
  ConfigureSportPage(
      {Key? key,
      required this.user,
      required this.not_conf_sports,
      required this.conf_sports})
      : super(key: key);

  @override
  State<ConfigureSportPage> createState() => _ConfigureSportPageState();
}

class _ConfigureSportPageState extends State<ConfigureSportPage> {
  String? _sport;
  String? _difficulty;
  List<bool> _isSelected = List.generate(3, (index) => false);
  bool _isFirstContainerVisible = false;
  bool _isSecondContainerVisible = false;
  String _diffFilter = "all";
  List<bool> _diffSelected = [false, false, false];
  int _diffValue = 0;
  int _dayValue = 0;
  String _dayFilter = "all";
  String sportName = "";
  int _index = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sportName = widget.not_conf_sports[_index];
  }

  void addSport(String uid, String dif, String sport) {
    // sportName = "Choose a sport";
    sportName = widget.not_conf_sports[_index + 1];
    SportServices().addSport(uid, dif, sport);
    setState() {}
    // print("@@@@@@@@GOT HERE");
    showSnackBar("The sport has been added!", context);
  }

  void deleteSport(String uid, String sport) {
    SportServices().deleteSport(uid, sport);
    sportName = widget.not_conf_sports[0];
    setState() {}
    print("%%%%%% Deleted sport $sport");
    // print("@@@@@@@@GOT HERE");
    showSnackBar("The sport has been added!", context);
  }

  Future<String> getNameFromId(String id) async {
    return (await SportServices().getSpecificSportFromId(id)).name;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: NaviBar(
          index: 3,
        ),
        body: Material(
          color: Colors.white,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProfilePic(profilePhoto: widget.user.profilePhoto),
                Text(
                  widget.user.fullName + ', ' + widget.user.country,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                      color: Color(0xfff575861)),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 5),
                          ]),
                      child: TextButton.icon(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0))),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white)),
                        label: Text(
                          'Add sport',
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () {
                          setState(() {
                            _isSecondContainerVisible = false;
                            _isFirstContainerVisible =
                                !_isFirstContainerVisible;
                          });
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.blue,
                          size: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 5),
                          ]),
                      child: TextButton.icon(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0))),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white)),
                        label: Text(
                          'Edit sport',
                          style: TextStyle(color: Colors.green),
                        ),
                        onPressed: () {
                          setState(() {
                            _isFirstContainerVisible = false;
                            _isSecondContainerVisible =
                                !_isSecondContainerVisible;
                          });
                        },
                        icon: Icon(
                          Icons.edit_note,
                          color: Colors.green,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                buildFirstContainer(),
                buildSecondContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildSportsDropDown() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // Safety check to ensure that snapshot contains data
          // without this safety check, StreamBuilder dirty state warnings will be thrown
          if (!snapshot.hasData)
            return const Center(
              child: CircularProgressIndicator(),
            );
          return DropdownButtonHideUnderline(
            child: DropdownButton2(
              isExpanded: true,
              hint: Row(
                children: [
                  SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Text(
                      sportName,
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
              items: snapshot.data!['sports_not_configured']
                  .map<DropdownMenuItem<String>>(
                      (item) => DropdownMenuItem<String>(
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
                                      text: item as String,
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
              value: sportName,
              onChanged: (value) {
                sportName = value.toString();
                _index =
                    snapshot.data!['sports_not_configured'].indexOf(sportName);
                print("index e  $_index");
                setState(
                  () {},
                );
              },
              icon: const Icon(Icons.arrow_downward_sharp),
              iconSize: 21,
              iconEnabledColor: Colors.black,
              buttonHeight: 50,
              buttonWidth: 180,
              buttonPadding: const EdgeInsets.only(left: 14, right: 14),
              buttonDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.black26,
                ),
                color: Colors.white,
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

  @override
  Widget buildFirstContainer() {
    return AnimatedContainer(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 35),
              child: Material(
                  color: Colors.white,
                  child: Column(
                    children: [
                      buildSportsDropDown(),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          buildDifficultyRadioText(
                              'assets/images/difficulty_icons/easy.png',
                              1,
                              'Easy'),
                          SizedBox(
                            width: 10,
                          ),
                          buildDifficultyRadioText(
                              'assets/images/difficulty_icons/medium.png',
                              2,
                              'Medium'),
                          SizedBox(
                            width: 10,
                          ),
                          buildDifficultyRadioText(
                              'assets/images/difficulty_icons/hard.png',
                              3,
                              'Hard'),
                        ],
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    label: Text('Configure'),
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      setState(() {
                        // clearFields();
                        print("Doing something?");
                        addSport(widget.user.uid, _diffFilter, sportName);
                      });
                    },
                  ),
                ],
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 5),
            ]),
        duration: Duration(seconds: 0),
        // color: Colors.red,
        height: _isFirstContainerVisible
            ? MediaQuery.of(context).size.height * 0.3
            : 0.0,
        width: _isFirstContainerVisible
            ? MediaQuery.of(context).size.width * 0.7
            : 0.0);
  }

  void clearFields() {
    _diffSelected[_diffValue - 1] = false;
  }

  @override
  Widget buildSecondContainer() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // Safety check to ensure that snapshot contains data
          // without this safety check, StreamBuilder dirty state warnings will be thrown
          if (!snapshot.hasData)
            return const Center(
              child: CircularProgressIndicator(),
            );
          return Center(
              child: Column(
            children: [
              AnimatedContainer(
                child: ListView.builder(
                  itemCount: snapshot.data!["sports_configured"].length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        contentPadding: EdgeInsets.only(left: 5, right: 5),
                        title: Row(
                          children: [
                            InkWell(
                              child: Icon(Icons.delete),
                              onTap: () => deleteSport(
                                  widget.user.uid,
                                  snapshot.data!["sports_configured"][index]
                                      .values.last),
                            ),
                            Text(
                              snapshot.data!["sports_configured"][index].values
                                  .last,
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        trailing: SizedBox(
                          width: 144,
                          height: 20,
                          child: Row(
                            children: [
                              buildDiffRadioText(1),
                              buildDiffRadioText(2),
                              buildDiffRadioText(3),
                            ],
                          ),
                        ),
                        // trailing: SizedBox(
                        //   width: 200,
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: <Widget>[
                        //       buildDiffRadioText(
                        //         1,
                        //       ),
                        //       buildDiffRadioText(
                        //         2,
                        //       ),
                        //       buildDiffRadioText(
                        //         3,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        onTap: () => print("ListTile"));
                  },
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 5),
                    ]),
                duration: Duration(seconds: 0),
                // color: Colors.red,
                height: _isSecondContainerVisible
                    ? MediaQuery.of(context).size.height * 0.3
                    : 0.0,
                width: _isSecondContainerVisible
                    ? MediaQuery.of(context).size.width * 0.7
                    : 0.0,
              ),
              // _isSecondContainerVisible
              //     ? TextButton(
              //         onPressed: () {
              //           print("SAVING");
              //         },
              //         child: Text('SAVE'),
              //       )
              //     : Container(),
            ],
          ));
        });
  }

  Widget buildDifficultyRadioText(String photo, int index, String diff) {
    return Column(
      children: [
        ElevatedButton(
            style: ButtonStyle(
              backgroundColor: _diffSelected[index - 1] == true
                  ? MaterialStateProperty.all(kPrimaryColor)
                  : MaterialStateProperty.all(Colors.white),
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected))
                    return Colors.redAccent; //<-- SEE HERE
                  return null; // Defer to the widget's default.
                },
              ),
            ),
            onPressed: () {
              setState(() {
                print("LADY $index");
                if (index == _diffValue) {
                  _diffSelected[index - 1] = !_diffSelected[index - 1];
                  _diffFilter = "all";
                  _diffValue = 0;
                } else {
                  for (int i = 0; i < _diffSelected.length; i++) {
                    if (index - 1 != i) {
                      _diffSelected[i] = false;
                    }
                  }
                  _diffSelected[index - 1] = !_diffSelected[index - 1];
                  _diffFilter = getDifFromValue(index);
                  _diffValue = index;
                }
                print("FILTER: $_diffFilter");
              });
            },
            child: Row(
              children: [
                Image.asset(
                  photo,
                  width: 25,
                  height: 25,
                  fit: BoxFit.cover,
                  // color: Colors.grey,
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            )),
        Text(diff,
            style: TextStyle(
              color: _diffSelected[index - 1] == true
                  ? Colors.white
                  : kPrimaryColor,
            )),
      ],
    );
  }

  String getDifFromValue(int v) {
    switch (v) {
      case 1:
        return 'Easy';
      case 2:
        return 'Medium';
      case 3:
        return 'Hard';
      default:
        return 'all';
    }
  }

  String getDayFromValue(int v) {
    switch (v) {
      case 1:
        return 'Morning';
      case 2:
        return 'Afternoon';
      case 3:
        return 'Night';
      default:
        return 'all';
    }
  }

  Widget buildDiffRadioText(int index) {
    return Theme(
      data: Theme.of(context).copyWith(
          unselectedWidgetColor: Colors.grey, disabledColor: Colors.blue),
      child: Radio(
        value: index,
        groupValue: _dayValue,
        onChanged: (value) {
          setState(() {
            setState(() {
              _dayFilter = getDayFromValue(index);
              print("OK $_dayFilter");
              _dayValue = index;
            });
          });
        },
      ),
    );
  }
}
