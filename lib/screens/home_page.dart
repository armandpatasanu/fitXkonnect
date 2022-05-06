import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitxkonnect/screens/navigation_page.dart';
import 'package:fitxkonnect/services/location_services.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/personal_match_card.dart';
import 'package:fitxkonnect/utils/widgets/match_card.dart';
import 'package:fitxkonnect/utils/widgets/special_match_card.dart';
import 'package:flutter/material.dart';
import 'package:multi_stream_builder/multi_stream_builder.dart';

class HomePage extends StatefulWidget {
  final snapshot;
  const HomePage({
    Key? key,
    this.snapshot,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(children: [
        Container(
          height: 120,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(50),
            ),
            color: Color.fromARGB(47, 143, 116, 36),
          ),
          child: Stack(children: [
            Positioned(
              top: 40,
              left: 0,
              child: Container(
                height: 60,
                width: 300,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                  color: kPrimaryLightColor,
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 4,
              child: TextButton.icon(
                label: Text(
                  "Available Matches",
                  style: TextStyle(
                    fontSize: 24,
                    color: Color.fromARGB(180, 69, 36, 255),
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                icon: Icon(
                  Icons.arrow_circle_left,
                  color: Color.fromARGB(180, 112, 91, 232),
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NavigationPage())),
              ),
            ),
          ]),
        ),
        Expanded(
          child: SizedBox(
            height: 10,
            child: ListView.builder(
              itemCount: widget.snapshot.data!.docs.length,
              itemBuilder: (context, index) => FutureBuilder(
                  future: Future.wait([
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.snapshot.data.docs[index]['player1'])
                        .get(),
                    FirebaseFirestore.instance
                        .collection('locations')
                        .doc(widget.snapshot.data.docs[index]['location'])
                        .get(),
                  ]),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<dynamic>> snep) {
                    if (snep.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return SpecialMatchCard(
                      snap: widget.snapshot.data!.docs[index].data(),
                      userSnap: snep.data![0],
                      locationSnap: snep.data![1],
                    );
                  }),
            ),
          ),
        ),
      ]),
    );
  }
}
