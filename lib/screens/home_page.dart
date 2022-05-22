import 'package:fitxkonnect/models/hp_match_model.dart';
import 'package:fitxkonnect/models/sport_model.dart';
import 'package:fitxkonnect/services/match_services.dart';
import 'package:fitxkonnect/services/sport_services.dart';
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
  List<SportModel> sports = [];
  List<bool> pressedAttentions = [];
  int _counter = 0;
  String _filter = "all";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Mihaitz");
    getSports();
  }

  List<Color> _color = [
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
  ];
  @override
  void getSports() async {
    sports = await SportServices().getListOfSports();
    pressedAttentions = sports.map((e) => false).toList();
  }

  Widget build(BuildContext context) {
    print("BUILDING");
    // getSports();
    return Scaffold(
      bottomNavigationBar: NaviBar(
        index: 0,
      ),
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
                height: 50,
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: Center(
                    child: Row(
                  children: [
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              for (int i = 0;
                                  i < pressedAttentions.length;
                                  i++) {
                                pressedAttentions[i] = false;
                              }
                              _filter = "all";
                            });
                          },
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Colors.redAccent; //<-- SEE HERE
                                return null; // Defer to the widget's default.
                              },
                            ),
                          ),
                          child: Icon(
                            Icons.restart_alt,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    Flexible(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: sports.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: pressedAttentions[index] ==
                                          true
                                      ? MaterialStateProperty.all(Colors.red)
                                      : MaterialStateProperty.all(Colors.amber),
                                  overlayColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.selected))
                                        return Colors.redAccent; //<-- SEE HERE
                                      return null; // Defer to the widget's default.
                                    },
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    print(
                                        " QUADUS: ${pressedAttentions[index]}");
                                    int found = 99;
                                    _counter = 0;
                                    for (int i = 0;
                                        i < pressedAttentions.length;
                                        i++) {
                                      if (pressedAttentions[i] == true) {
                                        _counter++;
                                        found = i;
                                      }
                                    }
                                    print("FOUNDER IS: $found");
                                    print("COUNTER IS: $_counter");
                                    if (_counter == 0) {
                                      pressedAttentions[index] = true;
                                      _filter = sports[index].name;
                                    } else if (_counter == 1 &&
                                        found == index) {
                                      pressedAttentions[found] = false;
                                      _filter = "all";
                                    } else if (_counter == 1 &&
                                        found != index) {
                                      pressedAttentions[found] = false;
                                      pressedAttentions[index] = true;
                                      _filter = sports[index].name;
                                    }

                                    print(
                                        " QUADUS: ${pressedAttentions[index]}");
                                    print("HMMMM: ${sports[index].name}");
                                    // _filter = sports[index].name;
                                  });
                                },
                                child: Text(sports[index].name),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ))),
            Container(
              height: 561,
              padding: EdgeInsets.only(top: 10),
              child: FutureBuilder(
                  future: MatchServices().getActualHomePageMatches(_filter),
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
                    return Container(
                      child: Column(children: [
                        Expanded(
                          child: SizedBox(
                            height: 10,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) =>
                                    SpecialMatchCard(
                                      snap: snapshot.data![index],
                                    )),
                          ),
                        ),
                      ]),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
