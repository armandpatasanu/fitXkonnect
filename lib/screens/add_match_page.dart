import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/providers/user_provider.dart';
import 'package:fitxkonnect/services/firestore_methods.dart';
import 'package:fitxkonnect/services/location_services.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/utils.dart';
import 'package:fitxkonnect/utils/widgets/date_time_picker.dart';
import 'package:fitxkonnect/utils/widgets/locations_dropdown.dart';
import 'package:fitxkonnect/utils/widgets/navi_bar.dart';
import 'package:fitxkonnect/utils/widgets/toggle_buttons.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'package:fitxkonnect/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddMatchPage extends StatefulWidget {
  @override
  _AddMatchPageState createState() => _AddMatchPageState();
}

class _AddMatchPageState extends State<AddMatchPage> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _sportController = TextEditingController();
  final TextEditingController _difficultyController = TextEditingController();
  bool _isLoading = false;
  List<bool> _isSelected = [false, false, false];
  late String difficulty;

  bool isSignupScreen = true;
  bool isMale = true;
  bool isRememberMe = false;
  String sportName = "Tenis";

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser();

    return Scaffold(
      bottomNavigationBar: NaviBar(
        index: 2,
      ),
      backgroundColor: Colors.grey[300],
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 700),
            curve: Curves.bounceInOut,
            top: isSignupScreen ? 200 : 230,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 700),
              curve: Curves.bounceInOut,
              height: isSignupScreen ? 380 : 250,
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width - 40,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5),
                  ]),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildSignupSection(),
                  ],
                ),
              ),
            ),
          ),
          buildBottomHalfContainer(false, user),
        ],
      ),
    );
  }

  Container buildSignupSection() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //buildTextField(Icons.place, "Location", _locationController),
          // buildTextField(Icons.sports_kabaddi, "Sport", _sportController),
          //buildSpec(),
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.calendar_month,
                        size: 18,
                        color: textColor1,
                      ),
                    ),
                    TextSpan(
                        text: "Pick a Difficulty",
                        style: TextStyle(fontSize: 15, color: textColor1)),
                  ],
                ),
              ),
              SizedBox(width: 10),
              buildToggle(),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          buildSportsDropwDownList(),
          buildLocationsDropDown(),
          // LocationsDropDownList(),
          SizedBox(
            height: 8,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(
                    Icons.calendar_month,
                    size: 17,
                    color: textColor1,
                  ),
                ),
                TextSpan(
                    text: "Select Match Date",
                    style: TextStyle(fontSize: 15, color: textColor1)),
              ],
            ),
          ),
          SizedBox(
            height: 4,
          ),
          DateTimeField(
            textAlign: TextAlign.center,
            controller: _dateTimeController,
            style: TextStyle(fontSize: 14, color: textColor1),
            decoration: InputDecoration(
              hintText: 'Choose match starting date&time',
              hintStyle: TextStyle(fontSize: 14, color: textColor1),
            ),
            format: DateFormat('MM/dd/yyyy HH:mm'),
            onShowPicker: (context, currentValue) async {
              final date = await showDatePicker(
                context: context,
                initialDate: currentValue ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                final time = await showTimePicker(
                    context: context,
                    initialTime:
                        TimeOfDay.fromDateTime(currentValue ?? DateTime.now()));
                return DateTimeField.combine(date, time);
              } else {
                return currentValue;
              }
            },
          )
        ],
      ),
    );
  }

  Widget buildBottomHalfContainer(bool showShadow, UserModel user) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 700),
      curve: Curves.bounceInOut,
      top: isSignupScreen ? 535 : 430,
      right: 0,
      left: 0,
      child: Center(
        child: Container(
          height: 90,
          width: 90,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                if (showShadow)
                  BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    spreadRadius: 1.5,
                    blurRadius: 10,
                  )
              ]),
          child: !showShadow
              ? Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.white,
                      kPrimaryColor,
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(.3),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 1))
                    ],
                  ),
                  child: InkWell(
                    onTap: () => createMatch(
                      user,
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                )
              : Center(),
        ),
      ),
    );
  }

  Widget buildTextField(
      IconData icon, String hintText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        style: TextStyle(color: kPrimaryColor),
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: iconColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          contentPadding: EdgeInsets.all(10),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14, color: textColor1),
        ),
      ),
    );
  }

  var setDefaultMake = true, setDefaultMakeModel = true;
  Widget buildSportsDropwDownList() {
    return FutureBuilder<QuerySnapshot>(
      future:
          FirebaseFirestore.instance.collection('sports').orderBy('name').get(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return DropdownButton(
          // hint: Text(
          //   "Choose a sport",
          //   style: TextStyle(color: textColor1),
          // ),
          value: sportName,
          icon: Icon(
            Icons.arrow_downward,
            size: 17,
            color: textColor1,
          ),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          isExpanded: false,
          items: snapshot.data!.docs.map((value) {
            return DropdownMenuItem(
              value: value.get('name'),
              child: Text('${value.get('name')}'),
            );
          }).toList(),
          onChanged: (value) {
            debugPrint('selected onchange: $value');
            setState(
              () {
                // Selected value will be stored
                debugPrint('BEFORE: $sportName');
                sportName = value.toString();
                debugPrint('AFTER: $sportName');
                // Default dropdown value won't be displayed anymore
              },
            );
          },
        );
      },
    );
  }

  String dropdownValue = 'Newest First';
  Widget buildSpec() {
    return DropdownButton(
      value: dropdownValue,
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      style: TextStyle(fontSize: 18, color: Colors.white),
      isExpanded: true,
      items:
          ['Newest First', 'Oldest First', 'Value High-Low', 'Value Low-High']
              .map((e) => DropdownMenuItem(
                    child: Text(e),
                    value: e,
                  ))
              .toList(),
      underline: Container(
        height: 3,
        color: Colors.teal,
      ),
    );
  }

  void updateString(String val) {
    difficulty = val;
  }

  Widget buildToggle() {
    return Flexible(
      child: ToggleButtons(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.density_medium,
                color: Colors.green,
                size: 20,
              ),
              Text('Easy'),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.thumb_down,
                color: Colors.yellow[800],
                size: 20,
              ),
              Text('Medium'),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.close,
                color: Colors.red[600],
                size: 20,
              ),
              Text('Hard'),
            ],
          ),
        ],
        textStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        onPressed: (int index) {
          setState(() {
            switch (index) {
              case 0:
                updateString('Easy');
                print('Easy');
                break;
              case 1:
                updateString('Medium');
                print('Medium');
                break;
              case 2:
                updateString('Hard');
                print('Hard');
                break;
            }
            for (int buttonIndex = 0;
                buttonIndex < _isSelected.length;
                buttonIndex++) {
              if (buttonIndex == index) {
                if (!_isSelected[index]) _isSelected[buttonIndex] = true;
              } else {
                _isSelected[buttonIndex] = false;
              }
            }
          });
        },
        isSelected: _isSelected,
        borderRadius: BorderRadius.circular(30),
        selectedColor: Colors.white,
        fillColor: Colors.teal,
        borderColor: Colors.teal,
        selectedBorderColor: Colors.teal,
        borderWidth: 2,
        splashColor: Colors.teal[100],
        constraints: BoxConstraints.expand(
            width:
                MediaQuery.of(context).size.width / (2.3 * _isSelected.length),
            height: 45),
      ),
    );
  }

  String? selectedValue;
  List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8',
  ];

  @override
  Widget buildLocationsDropDown() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('locations')
            .orderBy('name', descending: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                children: const [
                  Icon(
                    Icons.list,
                    size: 18,
                    color: Colors.yellow,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Text(
                      'Choose location',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              items: snapshot.data!.docs
                  .map((item) => DropdownMenuItem<String>(
                        value: item.get('name'),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.location_on,
                                  size: 18,
                                  color: textColor1,
                                ),
                              ),
                              TextSpan(
                                  text: item.get('name'),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: textColor1,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
              value: selectedValue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value as String;
                });
              },
              icon: const Icon(
                Icons.arrow_forward_ios_outlined,
              ),
              iconSize: 15,
              iconEnabledColor: Colors.yellow,
              buttonHeight: 50,
              buttonWidth: 200,
              buttonPadding: const EdgeInsets.only(left: 14, right: 14),
              buttonDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.black26,
                ),
                color: Colors.teal,
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

  void clearTextFields() {
    _dateTimeController.clear();
    _locationController.clear();
    _difficultyController.clear();
    _sportController.clear();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _dateTimeController.dispose();
    _locationController.dispose();
    _difficultyController.dispose();
    _sportController.dispose();
    super.dispose();
  }

  createMatch(UserModel user) async {
    setState(() {
      _isLoading = true;
    });

    try {
      String result = await FirestoreMethods().createMatch(
        user.uid,
        selectedValue!,
        user.uid,
        _dateTimeController.text.substring(11, 16),
        _dateTimeController.text.substring(0, 10),
        sportName,
        difficulty,
        'open',
      );
      print("LOCATION: ${selectedValue}");
      // print(DatetimePickerWidget());
      print("SPORT: ${sportName}");
      print(_dateTimeController.text);
      print("EMPTY RIGHT?: ${difficulty}");
      if (result == 'success') {
        setState(() {
          _isLoading = false;
        });
        showSnackBar('succesfully created a match!', context);
        clearTextFields();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(result, context);
      }
    } catch (error) {
      showSnackBar(error.toString(), context);
    }
  }
}
