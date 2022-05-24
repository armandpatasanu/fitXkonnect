import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/models/sport_model.dart';
import 'package:fitxkonnect/screens/location_filter_screen.dart';
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
  int _value = 0;
  List<bool> _isChecked = [];

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
              Text(
                'Difficulty',
                style: TextStyle(
                  fontSize: 21,
                  color: kPrimaryColor,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildDifficultyRadioText('Easy', 1),
                  buildDifficultyRadioText('Medium', 2),
                  buildDifficultyRadioText('Hard', 3),
                ],
              ),
              Text(
                'Part of day',
                style: TextStyle(
                  fontSize: 21,
                  color: kPrimaryColor,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildDifficultyRadioText('Morning', 1),
                  buildDifficultyRadioText('Afternoon', 2),
                  buildDifficultyRadioText('Night', 3),
                ],
              ),
              Container(
                color: Colors.white,
                height: 290,
                child: ListView.builder(
                  itemCount: widget.sports.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        leading: Checkbox(
                          checkColor: Colors.red,
                          activeColor: Colors.white,
                          value: _isChecked[index],
                          onChanged: (value) {
                            setState(() {
                              _isChecked[index] = value!;
                            });
                          },
                        ),
                        title: Text(
                          widget.sports[index].name,
                          style: TextStyle(
                            color: Colors.black,
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
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              FilterLocationScreen(
                            locations: widget.locations,
                            sports: widget.sports,
                          ),
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
                        _value = 0;
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
            groupValue: _value,
            onChanged: (value) {
              setState(() {
                setState(() {
                  _value = index;
                });
              });
            },
          ),
        ),
      ],
    );
  }
}
