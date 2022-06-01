import 'package:fitxkonnect/blocs/app_bloc.dart';
import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/services/location_services.dart';
import 'package:fitxkonnect/services/sport_services.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/widgets/navi_bar.dart';
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
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        // ),
        body: Container(
            child: FutureBuilder(
                future: Future.wait([
                  LocationServices().getMapOfLocations(),
                  SportServices().getListOfSports(),
                ]),
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return MapScreen(
                    filteredSport: "LIST",
                    loc_maps: snapshot.data![0],
                    listOfSports: snapshot.data![1],
                  );
                })),
        // child: MapScreen(
        //   locations: [],
        // ),
      ),
    );
  }
}
