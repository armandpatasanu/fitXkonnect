import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/models/sport_model.dart';
import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/providers/user_provider.dart';
import 'package:fitxkonnect/services/firestore_methods.dart';
import 'package:fitxkonnect/services/location_services.dart';
import 'package:fitxkonnect/services/sport_services.dart';
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

  bool _isLoading = false;
  List<bool> _isSelected = [false, false, false];
  String? selectedValue;

  bool isSignupScreen = true;
  bool isMale = true;
  bool isRememberMe = false;
  String sportName = "Choose Sport";

  @override
  Widget build(BuildContext context) {
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
          buildBottomHalfContainer(false),
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
                        Icons.local_activity,
                        size: 18,
                        color: textColor1,
                      ),
                    ),
                    TextSpan(
                        text: "Pick a sport",
                        style: TextStyle(fontSize: 18, color: textColor1)),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              buildSportsDropwDownList(),
            ],
          ),
          SizedBox(
            height: 12,
          ),

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

  Widget buildBottomHalfContainer(bool showShadow) {
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
                    onTap: () => createMatch(),
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
    return FutureBuilder<List<dynamic>>(
      future: SportServices()
          .getUsersSportsPlayed(FirebaseAuth.instance.currentUser!.uid),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return Container();
        }
        return DropdownButton(
          hint: Text(
            sportName,
            style: TextStyle(color: textColor1),
          ),
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
          items: snapshot.data!.map((whatdeactual) {
            return DropdownMenuItem(
              value: whatdeactual['sport'],
              child: Text(
                  '${whatdeactual['sport']} - ${whatdeactual['difficulty']}'),
            );
          }).toList(),
          onChanged: (value) {
            this.sportName = value.toString();
            debugPrint('selected onchange: $value');
            setState(
              () {
                sportName = value.toString();
              },
            );
          },
        );
      },
    );
  }

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
          if (!snapshot.hasData) return Container();
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

    _sportController.clear();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _dateTimeController.dispose();
    _locationController.dispose();

    _sportController.dispose();
    super.dispose();
  }

  createMatch() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String result = await FirestoreMethods().createMatch(
        FirebaseAuth.instance.currentUser!.uid,
        selectedValue!,
        _dateTimeController.text.substring(11, 16),
        _dateTimeController.text.substring(0, 10),
        sportName,
        'Idk how?',
        'open',
      );
      print("LOCATION: ${selectedValue}");
      // print(DatetimePickerWidget());
      print("SPORT: ${sportName}");
      print(_dateTimeController.text);

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
