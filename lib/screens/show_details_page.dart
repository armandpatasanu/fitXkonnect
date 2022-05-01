import 'package:fitxkonnect/screens/home_page.dart';
import 'package:fitxkonnect/screens/navigation_page.dart';
import 'package:flutter/material.dart';

class ShowDetails extends StatefulWidget {
  const ShowDetails({Key? key}) : super(key: key);

  @override
  State<ShowDetails> createState() => _ShowDetailsState();
}

class _ShowDetailsState extends State<ShowDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            // actions: [
            //   TextButton(
            //     onPressed: () => Navigator.pop(context),
            //     child: Text('Back'),
            //   ),
            // ],
            ),
        body: Center(
            child: FloatingActionButton(
          onPressed: (() => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NavigationPage()))),
        )));
  }
}
