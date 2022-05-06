import 'package:fitxkonnect/providers/string_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionToggle extends StatefulWidget {
  TransactionToggle({required this.children}) {
    _isSelected = List.generate(children.length, (index) => false);
  }
  final List<Widget> children;
  late final List<bool> _isSelected;
  @override
  _TransactionToggleState createState() => _TransactionToggleState();
}

class _TransactionToggleState extends State<TransactionToggle> {
  late String lol;
  void updateString(String val) {
    lol = val;
  }

  @override
  Widget build(BuildContext context) {
    var children = widget.children;
    var _isSelected = widget._isSelected;
    return Flexible(
      child: ToggleButtons(
        children: children,
        textStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        onPressed: (int index) {
          setState(() {
            switch (index) {
              case 0:
                updateString('Easy');
                print('Easy');
                break;
              case 1:
                updateString('Medium');
                print('Medium');
                break;
              case 2:
                updateString('Hard');
                print('Hard');
                break;
            }
            for (int buttonIndex = 0;
                buttonIndex < _isSelected.length;
                buttonIndex++) {
              if (buttonIndex == index) {
                if (!_isSelected[index]) _isSelected[buttonIndex] = true;
              } else {
                _isSelected[buttonIndex] = false;
              }
            }
          });
        },
        isSelected: _isSelected,
        borderRadius: BorderRadius.circular(30),
        selectedColor: Colors.white,
        fillColor: Colors.teal,
        borderColor: Colors.teal,
        selectedBorderColor: Colors.teal,
        borderWidth: 2,
        splashColor: Colors.teal[100],
        constraints: BoxConstraints.expand(
            width:
                MediaQuery.of(context).size.width / (2.3 * _isSelected.length),
            height: 45),
      ),
    );
  }
}
