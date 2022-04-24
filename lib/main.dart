import 'package:firebase_core/firebase_core.dart';
import 'package:fitxkonnect/mobile_screen_layout.dart';
import 'package:fitxkonnect/responsive_layout.dart';
import 'package:fitxkonnect/utils/colors.dart';
import 'package:fitxkonnect/web_screen_layout.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WHAT',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      home: const ResponsiveLayout(
        mSLayout: MobileScreenLayout(),
        wSLayout: WebScreenLayout(),
      ),
    );
  }
}
