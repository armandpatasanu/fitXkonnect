import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/widgets/icon_text_widget.dart';
import 'package:fitxkonnect/utils/widgets/text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateOfBirthField extends StatelessWidget {
  final TextEditingController controller;
  const DateOfBirthField({
    Key? key,
    this.hintText,
    this.icon = Icons.person,
    required this.controller,
  }) : super(key: key);
  final String? hintText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.only(left: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconAndTextWidget(
            text: 'Date of Birth',
            icon: Icons.calendar_month,
            color: kPrimaryColor,
            iconColor: kPrimaryColor,
          ),
          SizedBox(
            width: 10,
          ),
          // TextFieldContainer(
          //   child: TextFormField(
          //     controller: controller,
          //     cursorColor: kPrimaryColor,
          //     decoration: InputDecoration(
          //         icon: Icon(
          //           icon,
          //           color: kPrimaryColor,
          //         ),
          //         hintText: hintText,
          //         hintStyle: const TextStyle(
          //             fontFamily: 'OpenSans', color: kPrimaryColor),
          //         border: InputBorder.none),
          //   ),
          // ),
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              width: 190,
              decoration: BoxDecoration(
                color: kPrimaryLightColor,
                borderRadius: BorderRadius.circular(29),
              ),
              child: DateTimeField(
                textAlign: TextAlign.center,
                controller: controller,
                style: TextStyle(fontSize: 15, color: kPrimaryColor),
                decoration: InputDecoration(
                  fillColor: Colors.amber,
                  hintText: 'Pick Date',
                  hintStyle: TextStyle(
                      fontFamily: 'OpenSans',
                      color: kPrimaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                format: DateFormat('MM/dd/yyyy'),
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: currentValue ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    return date;
                  } else {
                    return currentValue;
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
