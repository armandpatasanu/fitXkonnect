import 'dart:typed_data';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:fitxkonnect/services/auth_methods.dart';
import 'package:fitxkonnect/screens/login_screen.dart';
import 'package:fitxkonnect/utils/colors.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/user_greeting/page_title_bar.dart';
import 'package:fitxkonnect/utils/user_greeting/under_part.dart';
import 'package:fitxkonnect/utils/widgets/age_widget.dart';
import 'package:fitxkonnect/utils/widgets/rounded_input_field.dart';
import 'package:fitxkonnect/utils/widgets/rounded_password_field.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../utils/utils.dart';
import '../utils/widgets/rounded_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
  String? _country;
  String? _age;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    print("AMBER ${_dateTimeController.text}");
    String result = await AuthMethods().registerValidation(
      email: _emailController.text,
      password: _passwordController.text,
      age: (DateTime.now().year -
              int.parse(_dateTimeController.text.substring(6, 10)))
          .toString(),
      fullName: _fullNameController.text,
      country: _country,
      file: _image,
      matches: [],
      sports: [],
    );

    print(result);

    setState(() {
      _isLoading = false;
    });
    if (result != 'success') {
      showSnackBar(result, context);
    } else {
      print("WHAT?");
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String countryToChange = "";
    return Scaffold(
      key: _scaffoldKey,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: size.width,
                height: size.height / 3,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                ),
                child: Center(
                  child: Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : const CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                'https://spng.pngfind.com/pngs/s/110-1102775_download-empty-profile-hd-png-download.png',
                              ),
                            ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: kPrimaryLightColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const PageTitleBar(
                topPadding: 220,
                title: 'Create New Account',
              ),
              Padding(
                padding: const EdgeInsets.only(top: 275.0),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            RoundedInputField(
                              hintText: "Email",
                              icon: Icons.email,
                              controller: _emailController,
                            ),
                            // RoundedInputField(
                            //   hintText: "Username",
                            //   icon: Icons.person,
                            //   controller: _usernameController,
                            // ),
                            RoundedInputField(
                              hintText: "Full Name",
                              icon: Icons.person,
                              controller: _fullNameController,
                            ),
                            DateOfBirthField(
                              hintText: "Email",
                              icon: Icons.email,
                              controller: _dateTimeController,
                            ),
                            RoundedPasswordField(
                              controller: _passwordController,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: OutlinedButton.icon(
                                      icon: const Text(
                                        'Choose your country',
                                        style: TextStyle(
                                            color: kPrimaryColor,
                                            fontFamily: 'OpenSans',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          width: 1.0,
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                      label: const Icon(
                                        Icons.map,
                                        color: kPrimaryColor,
                                      ),
                                      onPressed: () {
                                        showCountryPicker(
                                          context: context,
                                          showPhoneCode: false,
                                          showWorldWide: false,
                                          onSelect: (Country country) {
                                            setState(() {
                                              _country = country.countryCode +
                                                  country.flagEmoji;
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  _country != null
                                      ? Text('$_country',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'OpenSans',
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold))
                                      : Container(),
                                ],
                              ),
                            ),
                            RoundedButton(
                              isLoading: _isLoading,
                              text: 'REGISTER',
                              press: signUpUser,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            UnderPart(
                              title: "Already have an account?",
                              navigatorText: "Login here",
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()));
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
