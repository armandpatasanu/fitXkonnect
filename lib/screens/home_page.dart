import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:fitxkonnect/models/hp_match_model.dart';
import 'package:fitxkonnect/services/match_services.dart';
import 'package:fitxkonnect/services/sport_services.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/utils.dart';
import 'package:fitxkonnect/utils/widgets/home_match_skelet.dart';
import 'package:fitxkonnect/utils/widgets/navi_bar.dart';
import 'package:fitxkonnect/utils/widgets/notifications_page.dart';
import 'package:fitxkonnect/utils/widgets/special_match_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  // final snapshot;]
  final String password;
  HomePage({
    Key? key,
    required this.password,
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
  String callbeck = "not changed";
  @override
  void initState() {
    _getTaskAsync = SportServices().getButtonsSports();
    super.initState();

    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Allow Notifications'),
              content: Text('Our app would like to send you notifications'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Don\'t Allow',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context)),
                  child: Text(
                    'Allow',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
    // AwesomeNotifications()
    //     .createdStream
    //     .asBroadcastStream()
    //     .listen((notification) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Notification Created on ${notification.channelKey}'),
    //     ),
    //   );
    // });
    // AwesomeNotifications()
    //     .actionStream
    //     .asBroadcastStream()
    //     .listen((notification) {
    //   if (notification.channelKey == 'basic_channel') {
    //     AwesomeNotifications().getGlobalBadgeCounter().then(
    //           (value) =>
    //               AwesomeNotifications().setGlobalBadgeCounter(value - 1),
    //         );
    //   }
    //   Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(
    //         builder: (_) => NotificationsPage(
    //           password: widget.password,
    //         ),
    //       ),
    //       (route) => route.isFirst);
    // });
  }

  @override
  void dispose() {
    // AwesomeNotifications().actionSink.close();
    // AwesomeNotifications().createdSink.close();
    super.dispose();
  }

  callback(String value) {
    setState(() {
      callbeck = value;
    });
    print("LMAO $callbeck");
  }

  @override
  Widget build(BuildContext context) {
    print("LMAO $callbeck");
    return Scaffold(
      bottomNavigationBar: NaviBar(
        password: widget.password,
        index: 0,
      ),
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Container(
        color: Colors.white,
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
                                                Colors.purple[400]),
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
              height: 50,
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: Text('Available matches are:',
                  style: TextStyle(color: Colors.purple, fontSize: 16)),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 350,
              padding: EdgeInsets.only(top: 20),
              child: FutureBuilder(
                  future: MatchServices().getActualHomePageMatches(
                      _sportFilter, _diffFilter, _dayFilter),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<HomePageMatch>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        !snapshot.hasData) {
                      return Container(
                        child: Stack(children: [
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: 3,
                              itemBuilder: (context, index) =>
                                  LoadingMatchCard()),
                          Center(
                              child: Container(
                            height: 90,
                            child: Column(
                              children: [
                                SpinKitCircle(
                                  size: 50,
                                  itemBuilder: (context, index) {
                                    final colors = [
                                      Colors.white,
                                      Colors.purple
                                    ];
                                    final color = colors[index % colors.length];
                                    return DecoratedBox(
                                      decoration: BoxDecoration(color: color),
                                    );
                                  },
                                ),
                                Text('Refreshing matches',
                                    style: TextStyle(
                                        color: Colors.purple, fontSize: 16)),
                              ],
                            ),
                          )),
                        ]),
                      );
                    }
                    return snapshot.data!.length == 0
                        ? Center(
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 55, right: 40, bottom: 100),
                              width: MediaQuery.of(context).size.width,
                              child: Image.asset('assets/images/empty_list.png',
                                  fit: BoxFit.cover),
                            ),
                          )
                        : Container(
                            child: Column(children: [
                              Expanded(
                                child: SizedBox(
                                  height: 10,
                                  child: RefreshIndicator(
                                    strokeWidth: 3,
                                    displacement: 0,
                                    color: Colors.black,
                                    backgroundColor:
                                        Colors.grey.withOpacity(0.2),
                                    onRefresh: () {
                                      setState(() {});
                                      return Future.value(false);
                                    },
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, index) =>
                                            SpecialMatchCard(
                                                snap: snapshot.data![index],
                                                callbackFunction: callback)),
                                  ),
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
              unselectedWidgetColor: Colors.black,
              disabledColor: Colors.purple),
          child: Radio(
            value: index,
            activeColor: Colors.purple,
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
