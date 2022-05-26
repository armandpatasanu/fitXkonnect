import 'package:animations/animations.dart';
import 'package:fitxkonnect/models/location_model.dart';
import 'package:fitxkonnect/models/sport_model.dart';
import 'package:fitxkonnect/screens/details_page.dart';
import 'package:fitxkonnect/screens/filter_page.dart';
import 'package:fitxkonnect/screens/profile_page.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/widgets/custom_details_button.dart';
import 'package:fitxkonnect/utils/widgets/navi_bar.dart';
import 'package:fitxkonnect/utils/widgets/search_screen/map_screen.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class FilterLocationScreen extends StatefulWidget {
  final List<LocationModel> locations;
  final List<SportModel> sports;
  FilterLocationScreen({
    Key? key,
    required this.locations,
    required this.sports,
  }) : super(key: key);

  @override
  State<FilterLocationScreen> createState() => _FilterLocationScreenState();
}

class _FilterLocationScreenState extends State<FilterLocationScreen>
    with TickerProviderStateMixin {
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 2, vsync: this);

    return Scaffold(
      bottomNavigationBar: NaviBar(index: 1),
      body: Container(
        width: 500,
        height: 711,
        color: Colors.white,
        child: Stack(
          children: [
            // Container(
            //   color: Colors.white,
            //   child: TextButton.icon(
            //     //onPressed: handleMarkers,
            //     icon: Icon(Icons.sports_tennis),
            //     label: Text('Only this'),
            //   ),
            // ),
            Container(
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    margin: EdgeInsets.only(top: 37, left: 15),
                    height: 40,
                    width: 210,
                    decoration: BoxDecoration(
                      // gradient: LinearGradient(
                      //   colors: [
                      //     Colors.white,
                      //     Color.fromRGBO(255, 188, 143, 1),
                      //   ],
                      //   begin: Alignment.centerLeft,
                      //   end: Alignment.centerRight,
                      // ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      border: Border.all(color: Colors.grey.shade300),
                      color: Colors.grey.withOpacity(0.10),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.grey.withOpacity(0.3),
                      //     spreadRadius: 2,
                      //     blurRadius: 7,
                      //     offset: Offset(0, 1),
                      //   )
                      // ]),
                    ),
                    child: Container(
                      height: 30,
                      width: 50,
                      child: Row(
                        children: [
                          Icon(Icons.search, color: kPrimaryLightColor),
                          Flexible(
                            child: TextFormField(
                              onTap: () {},
                              controller: _locationController,
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                              cursorColor: kPrimaryColor,
                              decoration: InputDecoration(
                                  hintText: 'Search in Timișoara',
                                  hintStyle: const TextStyle(
                                    fontFamily: "Netflix",
                                    fontSize: 15,
                                    letterSpacing: 0.0,
                                    color: Colors.grey,
                                  ),
                                  border: InputBorder.none),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 37, left: 10),
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      // gradient: LinearGradient(
                      //   colors: [
                      //     Colors.white,
                      //     Color.fromRGBO(255, 188, 143, 1),
                      //   ],
                      //   begin: Alignment.centerLeft,
                      //   end: Alignment.centerRight,
                      // ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      border: Border.all(color: Colors.grey.shade300),
                      color: Colors.grey.withOpacity(0.10),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.grey.withOpacity(0.3),
                      //     spreadRadius: 2,
                      //     blurRadius: 7,
                      //     offset: Offset(0, 1),
                      //   )
                      // ]),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  MapScreen(
                                locations: widget.locations,
                                filteredSport: "LIST",
                                listOfSports: widget.sports,
                              ),
                              transitionDuration: Duration(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.map,
                              size: 25,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'MAP',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: "Netflix",
                                // fontWeight: FontWeight.w600,
                                fontWeight: ui.FontWeight.bold,
                                fontSize: 15,
                                letterSpacing: 0.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 34,
            ),
            Positioned(
              top: 110,
              child: Container(
                height: 604,
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: TabBarView(controller: _tabController, children: [
                  ListView.builder(
                    itemCount: widget.locations.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          trailing: SizedBox(
                            width: 90,
                            height: 20,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.sports_tennis,
                                  size: 20,
                                  color: kPrimaryColor,
                                ),
                                Icon(
                                  Icons.sports_football,
                                  size: 20,
                                  color: kPrimaryColor,
                                ),
                                Icon(
                                  Icons.sports_basketball,
                                  size: 20,
                                  color: kPrimaryColor,
                                ),
                              ],
                            ),
                          ),
                          leading: Column(
                            children: [
                              const Icon(
                                Icons.flight_land,
                                color: Colors.grey,
                              ),
                              Text(
                                '3.4 km',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          title: Text(
                            widget.locations[index].name,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            widget.locations[index].contact[0],
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          onTap: () => {
                                Navigator.of(context).pushReplacement(
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            DetailPage(
                                                locations: widget.locations,
                                                sports: widget.sports,
                                                locationId: widget
                                                    .locations[index]
                                                    .locationId),
                                    transitionDuration: Duration(),
                                  ),
                                )
                              });
                    },
                  ),
                  // Container(height: 600, child: EditPr()),
                  Container(
                    color: Colors.white,
                    child: FilterPage(
                        locations: widget.locations, sports: widget.sports),
                  ),
                ]),
              ),
            ),
            Positioned(
              top: 90,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                      indicatorColor: Colors.orange,
                      indicatorWeight: 4,
                      labelPadding: const EdgeInsets.only(left: 0, right: 0),
                      controller: _tabController,
                      labelColor: kPrimaryLightColor,
                      unselectedLabelColor: Colors.grey,
                      // isScrollable: true,
                      tabs: [
                        Tab(text: "LOCATIONS"),
                        Tab(text: "FILTER"),
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
