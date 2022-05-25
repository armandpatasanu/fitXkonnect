import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/models/sport_model.dart';
import 'package:fitxkonnect/screens/location_filter_screen.dart';
import 'package:fitxkonnect/services/location_services.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  final List<SportModel> sports;
  final List<LocationModel> locations;
  FilterPage({
    Key? key,
    required this.sports,
    required this.locations,
  }) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  int _diffValue = 0;
  int _dayValue = 0;
  List<bool> _isChecked = [];
  List<LocationModel> _locations = [];
  List<SportModel> _sports = [];

  @override
  void initState() {
    // TODO: implement initState
    _isChecked = List<bool>.filled(widget.sports.length, true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text(
              //   'Difficulty',
              //   style: TextStyle(
              //     fontSize: 21,
              //     color: kPrimaryColor,
              //     fontFamily: 'OpenSans',
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              // SizedBox(
              //   height: 5,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     buildDifficultyRadioText('Easy', 1),
              //     buildDifficultyRadioText('Medium', 2),
              //     buildDifficultyRadioText('Hard', 3),
              //   ],
              // ),
              // Text(
              //   'Part of day',
              //   style: TextStyle(
              //     fontSize: 21,
              //     color: kPrimaryColor,
              //     fontFamily: 'OpenSans',
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              // SizedBox(
              //   height: 5,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     buildDayRadioText('Morning', 1),
              //     buildDayRadioText('Afternoon', 2),
              //     buildDayRadioText('Night', 3),
              //   ],
              // ),
              Container(
                color: Colors.white,
                height: 550,
                child: ListView.builder(
                  itemCount: widget.sports.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        leading: Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                            checkColor: Colors.red,
                            activeColor: Colors.white,
                            value: _isChecked[index],
                            onChanged: (value) {
                              setState(() {
                                _isChecked[index] = value!;
                              });
                            },
                          ),
                        ),
                        title: Text(
                          widget.sports[index].name,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        onTap: () => print("ListTile"));
                  },
                ),
              ),
            ],
          ),
          Positioned(
            top: 480,
            left: 60,
            child: Row(
              children: [
                SizedBox(
                  width: 120,
                  height: 60,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(38.0),
                              side: BorderSide(color: Colors.red))),
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected))
                            return Colors.redAccent; //<-- SEE HERE
                          return null; // Defer to the widget's default.
                        },
                      ),
                    ),
                    onPressed: () {
                      for (int i = 0; i < widget.sports.length; i++) {
                        if (_isChecked[i] == true) {
                          _sports.add(widget.sports[i]);
                        }
                      }
                      for (var s in _sports) {
                        print("SPORTZ: ${s.name}");
                      }
                      String diffToPass = getDifFromValue(_diffValue);
                      String dayToPass = getDayFromValue(_dayValue);
                      // print(_diffValue + _dayValue);
                      // print(_dayValue);
                      print(diffToPass);
                      print(dayToPass);

                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              FutureBuilder<List<LocationModel>>(
                                  future: LocationServices()
                                      .getListOfLocationsBasedOfSelectedSports(
                                          _sports),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<LocationModel>>
                                          snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    return FilterLocationScreen(
                                      locations: snapshot.data!,
                                      sports: widget.sports,
                                    );
                                  }),
                          transitionDuration: Duration(),
                        ),
                      );
                    },
                    child: Text("APPLY"),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 120,
                  height: 60,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(38.0),
                              side: BorderSide(color: Colors.grey))),
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
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
                        _isChecked =
                            List<bool>.filled(widget.sports.length, false);
                        _diffValue = 0;
                        _dayValue = 0;
                      });
                    },
                    child: Text("CLEAR"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDifficultyRadioText(String diff, int index) {
    return Row(
      children: [
        Text(
          diff,
          style: TextStyle(color: kPrimaryColor),
        ),
        SizedBox(
          width: 5,
        ),
        Theme(
          data: Theme.of(context).copyWith(
              unselectedWidgetColor: Colors.grey, disabledColor: Colors.blue),
          child: Radio(
            value: index,
            groupValue: _diffValue,
            onChanged: (value) {
              setState(() {
                setState(() {
                  _diffValue = index;
                });
              });
            },
          ),
        ),
      ],
    );
  }

  Widget buildDayRadioText(String day, int index) {
    return Row(
      children: [
        Text(
          day,
          style: TextStyle(color: kPrimaryColor),
        ),
        SizedBox(
          width: 5,
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
                  _dayValue = index;
                });
              });
            },
          ),
        ),
      ],
    );
  }

  String getDifFromValue(int v) {
    switch (v) {
      case 1:
        return 'Easy';
      case 2:
        return 'Medium';
      case 3:
        return 'Hard';
      default:
        return 'default';
    }
  }

  String getDayFromValue(int v) {
    switch (v) {
      case 1:
        return 'Morning';
      case 2:
        return 'Afternoon';
      case 3:
        return 'Night';
      default:
        return 'default';
    }
  }
}
