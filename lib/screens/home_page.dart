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
            const Positioned(
              top: 115,
              left: 20,
              child: Text(
                "Matches",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                ),
              ),
            )
          ]),
        ),
        // SizedBox(
        //   height: height * 0.01,
        // ),
        Expanded(
          child: SizedBox(
            height: 10,
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) => MatchCard(),
            ),
          ),
        ),
      ]),
    );
  }
}
