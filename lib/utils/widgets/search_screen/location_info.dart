import 'package:fitxkonnect/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationInfo extends StatelessWidget {
  const LocationInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(30),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset.zero)
            ]),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRect(
                        child: Image.asset('assets/images/banu_sport.png',
                            width: 60, height: 60, fit: BoxFit.cover),
                      ),
                      Positioned(
                        bottom: -10,
                        right: 0,
                        child: Icon(
                          Icons.directions,
                          color: kPrimaryColor,
                        ),
                      )
                    ],
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location: Banu Sport',
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        Text(
                          'Available matches: 4',
                          style: TextStyle(color: Colors.amber),
                        ),
                        Text('Tennis, Badminton, Futsal',
                            style: TextStyle(color: kPrimaryColor))
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Show',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      // icon: Icon(
                      //   Icons.arrow_right_alt,
                      //   color: Colors.white,
                      // ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Center(
  //     child: Padding(
  //       padding: EdgeInsets.all(10),
  //       child: Card(
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Stack(),
  //             Padding(
  //               padding:
  //                   EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 16),
  //               child: Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       '4 matches open',
  //                       style: TextStyle(
  //                         color: kPrimaryColor,
  //                         fontFamily: 'OpenSans',
  //                       ),
  //                     ),
  //                     Text('Sports searched:'),
  //                     Text('tenis, badminton, legsccer'),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             ButtonBar(
  //               alignment: MainAxisAlignment.start,
  //               children: [
  //                 FloatingActionButton(
  //                   onPressed: () {
  //                     // Perform some action
  //                   },
  //                   child: const Text('See route'),
  //                 ),
  //                 FloatingActionButton(
  //                   onPressed: () {
  //                     // Perform some action
  //                   },
  //                   child: const Text('Show matches'),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
