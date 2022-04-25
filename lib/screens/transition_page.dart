import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:fitxkonnect/screens/add_match_page.dart';
import 'package:fitxkonnect/screens/home_page.dart';
import 'package:fitxkonnect/screens/profile_page.dart';
import 'package:fitxkonnect/screens/search_page.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:flutter/material.dart';

class TransitionPage extends StatefulWidget {
  const TransitionPage({Key? key}) : super(key: key);

  @override
  State<TransitionPage> createState() => _TransitionPageState();
}

class _TransitionPageState extends State<TransitionPage> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget buildBody() {
    switch (index) {
      case 1:
        return SearchPage();
      case 2:
        return AddMatchPage();
      case 3:
        return ProfilePage();
      default:
        return HomePage();
    }
  }

  Widget buildBottomNavigationBar() {
    return BottomNavyBar(
      backgroundColor: Colors.black,
      containerHeight: 60,
      selectedIndex: index,
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
          textAlign: TextAlign.center,
          activeColor: Colors.green,
          inactiveColor: Colors.grey,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.search),
          title: Text('Search'),
          textAlign: TextAlign.center,
          activeColor: Colors.amber,
          inactiveColor: Colors.grey,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.add),
          title: Text('Create'),
          textAlign: TextAlign.center,
          activeColor: Colors.red,
          inactiveColor: Colors.grey,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.people),
          title: Text('Profile'),
          textAlign: TextAlign.center,
          activeColor: Colors.yellow,
          inactiveColor: Colors.grey,
        ),
      ],
      onItemSelected: (index) => setState(() {
        this.index = index;
      }),
    );
  }
}
