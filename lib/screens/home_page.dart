import 'package:fitxkonnect/models/hp_match_model.dart';
import 'package:fitxkonnect/services/match_services.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/widgets/navi_bar.dart';
import 'package:fitxkonnect/utils/widgets/special_match_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  // final snapshot;
  const HomePage({
    Key? key,
    // this.snapshot,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: MatchServices().getActualHomePageMatches(),
        builder: (BuildContext context,
            AsyncSnapshot<List<HomePageMatch>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
            bottomNavigationBar: NaviBar(
              index: 0,
            ),
            body: Container(
              child: Column(children: [
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
                  ]),
                ),
                Expanded(
                  child: SizedBox(
                    height: 10,
                    child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) => SpecialMatchCard(
                              snap: snapshot.data![index],
                            )),
                  ),
                ),
              ]),
            ),
          );
        });
  }
}
