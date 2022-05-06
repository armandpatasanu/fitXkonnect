import 'package:fitxkonnect/screens/simple_appbar.dart';
import 'package:fitxkonnect/screens/transparent_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyMatches extends StatelessWidget {
  static final String title = 'AppBar';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
          primaryColor: Colors.purple,
        ),
        home: MainPage(title: title),
      );
}

class MainPage extends StatefulWidget {
  final String title;

  const MainPage({
    required this.title,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 1;

  @override
  Widget build(BuildContext context) => Scaffold(
        bottomNavigationBar: buildBottomBar(),
        body: buildPages(),
      );

  Widget buildBottomBar() {
    final style = TextStyle(color: Colors.white);

    return BottomNavigationBar(
      backgroundColor: Colors.purple,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      currentIndex: index,
      items: [
        BottomNavigationBarItem(
          icon: Text('AppBar', style: style),
          label: 'Normal',
        ),
        BottomNavigationBarItem(
          icon: Text('AppBar', style: style),
          label: 'Transparent',
        ),
      ],
      onTap: (int index) => setState(() => this.index = index),
    );
  }

  Widget buildPages() {
    switch (index) {
      case 0:
        return SimpleAppBarPage();
      case 1:
        return TransparentAppBarPage();
      default:
        return Container();
    }
  }
}
