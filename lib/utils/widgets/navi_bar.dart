import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:fitxkonnect/screens/add_match_page.dart';
import 'package:fitxkonnect/screens/home_page.dart';
import 'package:fitxkonnect/screens/profile_page.dart';
import 'package:fitxkonnect/screens/search_page.dart';
import 'package:flutter/material.dart';

class NaviBar extends StatefulWidget {
  final int index;
  const NaviBar({Key? key, required this.index}) : super(key: key);

  @override
  State<NaviBar> createState() => _NaviBarState();
}

class _NaviBarState extends State<NaviBar> {
  int index = 0;

  void buildBody(BuildContext context) {
    switch (index) {
      case 1:
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => SearchPage(),
            transitionDuration: Duration(),
          ),
        );
        break;
      case 2:
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => AddMatchPage(),
            transitionDuration: Duration(),
          ),
        );
        break;
      case 3:
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => ProfilePage(),
            transitionDuration: Duration(),
          ),
        );
        break;
      // default:
      //   return FutureBuilder(
      //       future: MatchServices().getHomePageMatches(),
      //       builder: (BuildContext context,
      //           AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
      //         if (snapshot.connectionState == ConnectionState.waiting) {
      //           return const Center(
      //             child: CircularProgressIndicator(),
      //           );
      //         }
      //         return HomePage(snapshot: snapshot);
      //       });
      default:
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => HomePage(),
            transitionDuration: Duration(),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavyBar(
      backgroundColor: Colors.white,
      containerHeight: 65,
      selectedIndex: widget.index,
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: Icon(
            Icons.home,
          ),
          title: Text('Home'),
          textAlign: TextAlign.center,
          activeColor: Colors.purple,
          inactiveColor: Colors.grey,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.search),
          title: Text('Search'),
          textAlign: TextAlign.center,
          activeColor: Colors.purple,
          inactiveColor: Colors.grey,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.add),
          title: Text('Create'),
          textAlign: TextAlign.center,
          activeColor: Colors.purple,
          inactiveColor: Colors.grey,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.people),
          title: Text('My Account'),
          textAlign: TextAlign.center,
          activeColor: Colors.purple,
          inactiveColor: Colors.grey,
        ),
      ],
      onItemSelected: (index) => setState(() {
        this.index = index;
        buildBody(context);
      }),
    );
  }
}
