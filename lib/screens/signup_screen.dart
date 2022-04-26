import 'dart:typed_data';

import 'package:fitxkonnect/methods/auth_methods.dart';
import 'package:fitxkonnect/screens/navigation_page.dart';
import 'package:fitxkonnect/screens/login_screen.dart';
import 'package:fitxkonnect/utils/colors.dart';
import 'package:fitxkonnect/utils/components/upside.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/widgets/rounded_input_field.dart';
import 'package:fitxkonnect/utils/widgets/rounded_password_field.dart';
import 'package:flutter/material.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/components/page_title_bar.dart';
import '../utils/components/under_part.dart';
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
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
  Gender? _gender;
  String? _country;

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  void updateGender(Gender? gender) {
    setState(() {
      _gender = gender;
      print(_gender);
    });
  }

  void signUpUser() async {
    // setState(() {
    //   _isLoading = true;
    // });
    String result = await AuthMethods().registerValidation(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        gender: _gender,
        country: _country,
        file: _image);

    print(result);

    // setState(() {
    //   _isLoading = false;
    // });
    if (result != 'success') {
      showSnackBar(result, context);
    } else {
      print("WHAT?");
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const NavigationPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String countryToChange = "";
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  width: size.width,
                  height: size.height / 2.5,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                  ),
                  padding: const EdgeInsets.all(50.0),
                  child: Center(
                    child: Stack(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        _image != null
                            ? CircleAvatar(
                                radius: 64,
                                backgroundImage: MemoryImage(_image!),
                              )
                            // ignore: prefer_const_constructors
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
                // const Upside(
                //   imgUrl: "assets/images/register.png",
                // ),
                const PageTitleBar(title: 'Create New Account'),
                Padding(
                  padding: const EdgeInsets.only(top: 320.0),
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
                          child: Column(
                            children: [
                              RoundedInputField(
                                hintText: "Email",
                                icon: Icons.email,
                                controller: _emailController,
                              ),
                              RoundedInputField(
                                hintText: "Username",
                                icon: Icons.person,
                                controller: _usernameController,
                              ),
                              RoundedPasswordField(
                                controller: _passwordController,
                              ),
                              GenderPickerWithImage(
                                showOtherGender: false,
                                verticalAlignedText: false,
                                selectedGenderTextStyle: const TextStyle(
                                    color: Color(0xFF8b32a8),
                                    fontWeight: FontWeight.bold),
                                unSelectedGenderTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
                                onChanged: (Gender? gender) {
                                  updateGender(gender);
                                },
                                equallyAligned: true,
                                animationDuration:
                                    const Duration(milliseconds: 300),
                                isCircular: true,
                                // default : true,
                                opacityOfGradient: 0.4,
                                padding: const EdgeInsets.all(3),
                                size: 50, //default : 40
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
                                        label: const Icon(Icons.map),
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
      ),
    );
  }
}
