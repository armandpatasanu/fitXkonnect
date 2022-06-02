import 'package:fitxkonnect/models/hp_match_model.dart';
import 'package:fitxkonnect/services/match_services.dart';
import 'package:fitxkonnect/services/sport_services.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/utils.dart';
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
  List<Map<String, bool>> _sportsButtons = [];
  Future<List<Map<String, bool>>>? _getTaskAsync;
  int _counter = 0;
  int _diffValue = 0;
  String _diffFilter = "all";
  String _dayFilter = "all";
  int _dayValue = 0;
  String _sportFilter = "all";
  List<bool> _diffSelected = [false, false, false];
  List<bool> _daySelected = [false, false, false];
  @override
  void initState() {
    // TODO: implement initState
    _getTaskAsync = SportServices().getButtonsSports();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NaviBar(
        index: 0,
      ),
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Container(
        color: kPrimaryColor,
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
                    Flexible(
                      child: FutureBuilder<List<Map<String, bool>>>(
                          future: _getTaskAsync,
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting ||
                                !snapshot.hasData) {
                              return Container();
                            }
                            _sportsButtons = snapshot.data!;
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor: _sportsButtons[index]
                                                    .values
                                                    .first ==
                                                true
                                            ? MaterialStateProperty.all(
                                                Colors.red)
                                            : MaterialStateProperty.all(
                                                Colors.amber),
                                        overlayColor: MaterialStateProperty
                                            .resolveWith<Color?>(
                                          (Set<MaterialState> states) {
                                            if (states.contains(
                                                MaterialState.selected))
                                              return Colors
                                                  .redAccent; //<-- SEE HERE
                                            return null; // Defer to the widget's default.
                                          },
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          int found = 99;
                                          _counter = 0;
                                          for (int i = 0;
                                              i < _sportsButtons.length;
                                              i++) {
                                            if (_sportsButtons[i]
                                                    .values
                                                    .first ==
                                                true) {
                                              _counter++;
                                              found = i;
                                            }
                                          }
                                          if (_counter == 0) {
                                            _sportsButtons[index].update(
                                                _sportsButtons[index]
                                                    .keys
                                                    .first,
                                                (value) => value = true);

                                            _sportFilter = _sportsButtons[index]
                                                .keys
                                                .first;
                                          } else if (_counter == 1 &&
                                              found == index) {
                                            _sportsButtons[found].update(
                                                _sportsButtons[found]
                                                    .keys
                                                    .first,
                                                (value) => value = false);
                                            _sportFilter = "all";
                                          } else if (_counter == 1 &&
                                              found != index) {
                                            _sportsButtons[found].update(
                                                _sportsButtons[found]
                                                    .keys
                                                    .first,
                                                (value) => value = false);
                                            _sportsButtons[index].update(
                                                _sportsButtons[index]
                                                    .keys
                                                    .first,
                                                (value) => value = true);
                                            _sportFilter = _sportsButtons[index]
                                                .keys
                                                .first;
                                          }
                                        });
                                      },
                                      child: Text(
                                          snapshot.data![index].keys.first),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                );
                              },
                            );
                          }),
                    ),
                  ],
                ))),
            Container(
                height: 50,
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      buildDifficultyRadioText(
                          'assets/images/difficulty_icons/easy.png', 1, 'Easy'),
                      SizedBox(
                        width: 10,
                      ),
                      buildDifficultyRadioText(
                          'assets/images/difficulty_icons/medium.png',
                          2,
                          'Medium'),
                      SizedBox(
                        width: 10,
                      ),
                      buildDifficultyRadioText(
                          'assets/images/difficulty_icons/hard.png', 3, 'Hard'),
                    ],
                  ),
                )),
            Container(
                height: 50,
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Time',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      buildDayRadioText(
                        'assets/images/time_icons/morning.png',
                        1,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      buildDayRadioText(
                          'assets/images/time_icons/afternoon.png', 2),
                      SizedBox(
                        width: 15,
                      ),
                      buildDayRadioText(
                          'assets/images/time_icons/night.png', 3),
                      SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        child: Icon(
                          Icons.lock_reset,
                          color: Colors.blue,
                          size: 28,
                        ),
                        onTap: () {
                          setState(() {
                            _dayValue = 0;
                            _dayFilter = "all";
                          });
                        },
                      ),
                    ],
                  ),
                )),
            Container(
              height: 511,
              padding: EdgeInsets.only(top: 10),
              child: FutureBuilder(
                  future: MatchServices().getActualHomePageMatches(
                      _sportFilter, _diffFilter, _dayFilter),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<HomePageMatch>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        !snapshot.hasData) {
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

  Widget buildDifficultyRadioText(String photo, int index, String diff) {
    return Row(
      children: [
        ElevatedButton(
            style: ButtonStyle(
              backgroundColor: _diffSelected[index - 1] == true
                  ? MaterialStateProperty.all(kPrimaryColor)
                  : MaterialStateProperty.all(Colors.white),
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected))
                    return Colors.redAccent; //<-- SEE HERE
                  return null; // Defer to the widget's default.
                },
              ),
            ),
            onPressed: () {
              setState(() {
                if (index == _diffValue) {
                  _diffSelected[index - 1] = !_diffSelected[index - 1];
                  _diffFilter = "all";
                  _diffValue = 0;
                } else {
                  for (int i = 0; i < _diffSelected.length; i++) {
                    if (index - 1 != i) {
                      _diffSelected[i] = false;
                    }
                  }
                  _diffSelected[index - 1] = !_diffSelected[index - 1];
                  _diffFilter = getDifFromValue(index);
                  _diffValue = index;
                }
              });
            },
            child: Row(
              children: [
                Image.asset(
                  photo,
                  width: 25,
                  height: 25,
                  fit: BoxFit.cover,
                  // color: Colors.grey,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(diff,
                    style: TextStyle(
                      color: _diffSelected[index - 1] == true
                          ? Colors.white
                          : kPrimaryColor,
                    )),
              ],
            )),
      ],
    );
  }

  Widget buildDayRadioText(String photo, int index) {
    return Row(
      children: [
        Image.asset(
          photo,
          width: 33,
          height: 33,
          fit: BoxFit.cover,
          // color: Colors.grey,
        ),
        Theme(
          data: Theme.of(context).copyWith(
              unselectedWidgetColor: Colors.grey, disabledColor: Colors.blue),
          child: Radio(
            value: index,
            groupValue: _dayValue,
            onChanged: (value) {
              setState(() {
                setState(() {
                  _dayFilter = getDayFromValue(index);
                  _dayValue = index;
                });
              });
            },
          ),
        ),
      ],
    );
  }
}
