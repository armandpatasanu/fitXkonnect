import 'package:fitxkonnect/blocs/app_bloc.dart';
import 'package:fitxkonnect/utils/widgets/search_screen/map_screen.dart';
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
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.menu),
          title: Text('Page title'),
          actions: [
            Icon(Icons.favorite),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.search),
            ),
            Icon(Icons.more_vert),
          ],
          // backgroundColor: Colors.purple,
        ),
        body: MapScreen(),
      ),
    );
  }
}
