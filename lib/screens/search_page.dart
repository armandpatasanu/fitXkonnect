import 'package:fitxkonnect/blocs/app_bloc.dart';
import 'package:fitxkonnect/utils/widgets/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ((context) => AppBloc()),
      child: Container(
        child: MapScreen(),
      ),
    );
  }
}
