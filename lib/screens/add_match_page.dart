import 'package:flutter/material.dart';

class AddMatchPage extends StatefulWidget {
  const AddMatchPage({Key? key}) : super(key: key);

  @override
  State<AddMatchPage> createState() => _AddMatchPageState();
}

class _AddMatchPageState extends State<AddMatchPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Add a game'),
    );
  }
}
