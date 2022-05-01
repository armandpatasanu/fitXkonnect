import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitxkonnect/screens/navigation_page.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/widgets/match_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        Container(
          height: 230,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(50),
            ),
            color: kPrimaryColor,
          ),
          child: Stack(children: [
            Positioned(
              top: 80,
              left: 0,
              child: Container(
                height: 100,
                width: 300,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: 115,
              left: 20,
              child: TextButton.icon(
                label: Text(
                  "Matches",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontFamily: 'OpenSans',
                  ),
                ),
                icon: Icon(Icons.arrow_circle_left),
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
            child: FutureBuilder(
              future: FirebaseFirestore.instance.collection("matches").get(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => MatchCard(
                    snap: snapshot.data!.docs[index].data(),
                  ),
                );
              },
            ),
          ),
        ),
      ]),
    );
  }
}
