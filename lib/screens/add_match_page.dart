import 'package:fitxkonnect/models/user_model.dart';
import 'package:fitxkonnect/providers/user_provider.dart';
import 'package:fitxkonnect/services/firestore_methods.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:fitxkonnect/utils/colors.dart';
import 'package:provider/provider.dart';

class AddMatchPage extends StatefulWidget {
  @override
  _AddMatchPageState createState() => _AddMatchPageState();
}

class _AddMatchPageState extends State<AddMatchPage> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _sportController = TextEditingController();
  final TextEditingController _difficultyController = TextEditingController();
  bool _isLoading = false;

  bool isSignupScreen = true;
  bool isMale = true;
  bool isRememberMe = false;

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser();

    return Scaffold(
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
        children: [
          buildTextField(Icons.place, "Location", _locationController),
          buildTextField(Icons.sports_kabaddi, "Sport", _sportController),
          buildTextField(Icons.quiz, "Difficulty", _difficultyController),
          buildTextField(Icons.date_range, "Date", _dateController),
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

  void clearTextFields() {
    _dateController.clear();
    _locationController.clear();
    _difficultyController.clear();
    _sportController.clear();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _dateController.dispose();
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
          _locationController.text,
          user.uid,
          _dateController.text,
          _sportController.text,
          _difficultyController.text);

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
