import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/utils.dart';
import 'package:fitxkonnect/utils/widgets/icon_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class SpecialMatchCard extends StatefulWidget {
  final snap;
  const SpecialMatchCard({
    Key? key,
    this.snap,
  }) : super(key: key);

  @override
  State<SpecialMatchCard> createState() => _SpecialMatchCardState();
}

class _SpecialMatchCardState extends State<SpecialMatchCard> {
  var userData = {};
  bool isLoading = false;
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.snap['player1'])
          .get();

      userData = userSnap.data()!;

      setState(() {});
    } catch (e) {
      showSnackBar(
        e.toString(),
        context,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      height: 250,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Stack(
        children: [
          Container(
            height: 200,
            margin: EdgeInsets.only(left: 40, right: 40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: kPrimaryLightColor,
              image: DecorationImage(
                  colorFilter: new ColorFilter.mode(
                      Colors.black.withOpacity(0.2), BlendMode.dstATop),
                  image: NetworkImage(
                    'https://jooinn.com/images/sunny-day-1.jpg',
                  ),
                  fit: BoxFit.cover),
            ),
          ),
          Stack(
            children: [
              Container(
                height: 250,
              ),
              Positioned(
                top: 150,
                child: Container(
                  height: 100,
                  margin: EdgeInsets.only(left: 15, right: 20, bottom: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color.fromARGB(255, 198, 171, 171),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                    child: Column(
                      children: [
                        Text(
                          (userData['fullName'] ?? 'Testing') + ", 21",
                          style: TextStyle(fontSize: 18, color: kPrimaryColor),
                        ),
                        SizedBox(
                          height: 0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Sport: ',
                                  style: TextStyle(color: kPrimaryColor),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                IconAndTextWidget(
                                  icon: Icons.sports_tennis,
                                  text: "Tenis",
                                  color: Colors.white,
                                  iconColor: Colors.yellow,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Difficulty: ',
                                  style: TextStyle(color: kPrimaryColor),
                                ),
                                IconAndTextWidget(
                                  icon: Icons.question_answer,
                                  text: "Hard",
                                  color: Colors.white,
                                  iconColor: Colors.yellow,
                                ),
                                // SizedBox(
                                //   width: 10,
                                // ),
                                // IconAndTextWidget(
                                //   icon: Icons.location_city,
                                //   text: "Medium",
                                //   color: Colors.grey,
                                //   iconColor: Colors.green,
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.network(
                      'https://images.mubicdn.net/images/cast_member/2552/cache-207-1524922850/image-w856.jpg?size=800x',
                      width: 150,
                      height: 150,
                      fit: BoxFit.scaleDown),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
