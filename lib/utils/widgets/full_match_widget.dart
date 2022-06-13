import 'package:fitxkonnect/models/full_match_model.dart';
import 'package:fitxkonnect/services/match_services.dart';
import 'package:fitxkonnect/utils/components/profile_page/profile_pic.dart';
import 'package:fitxkonnect/utils/constants.dart';
import 'package:fitxkonnect/utils/utils.dart';
import 'package:flutter/material.dart';

class FullMatchCard extends StatefulWidget {
  final FullMatch match;
  final Function callbackFunction;
  FullMatchCard({Key? key, required this.match, required this.callbackFunction})
      : super(key: key);

  @override
  State<FullMatchCard> createState() => _FullMatchCardState();
}

class _FullMatchCardState extends State<FullMatchCard> {
  List<String> statuses = ["played", "abandoned"];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 24.0, bottom: 24, left: 12, right: 12),
      child: Stack(
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(16),
              height: 180,
              decoration: widget.match.status == 'matched'
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                          colors: [Color(0xff6DC8F3), Color(0xff73A1F9)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade200,
                          blurRadius: 22,
                          offset: Offset(0, 6),
                        ),
                      ],
                    )
                  : widget.match.status == 'abandoned'
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                              colors: [
                                Colors.grey.shade300,
                                Colors.grey.shade500,
                                Colors.grey.shade800,
                                Colors.grey.shade500,
                                Colors.grey.shade300,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade600,
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                        )
                      : BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                              colors: [
                                Colors.green.shade300,
                                Colors.green.shade500,
                                Colors.green.shade800,
                                Colors.green.shade500,
                                Colors.green.shade300,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade600,
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                        )),
          Positioned(
              left: 95,
              top: 10,
              child: Container(
                width: 180,
                height: 170,
                // color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      width: 110,
                      // color: Colors.red,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              child: Icon(
                                Icons.info,
                                color: Colors.white,
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: SizedBox.expand(
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              widget.match.status == 'abandoned'
                                                  ? Column(
                                                      children: [
                                                        Text(
                                                          "ABANDONED",
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                      ],
                                                    )
                                                  : Container(),
                                              widget.match.status == 'played'
                                                  ? Column(
                                                      children: [
                                                        Text(
                                                          "PLAYED",
                                                          style: TextStyle(
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                      ],
                                                    )
                                                  : Container(),
                                              Text(
                                                "Sport played: ${widget.match.sport}",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                "Match difficulty: ${widget.match.difficulty}",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                "Location: ${widget.match.locationAddress}",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                    shape: MaterialStateProperty
                                                        .all(RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30.0))),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.black)),
                                                child: Text('Okay'),
                                                onPressed: () => {
                                                  Navigator.of(context).pop()
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            !statuses.contains(widget.match.status)
                                ? SizedBox(
                                    width: 10,
                                  )
                                : Container(),
                            !statuses.contains(widget.match.status)
                                ? InkWell(
                                    child:
                                        Icon(Icons.close, color: Colors.white),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                          child: Container(
                                            height: 200,
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: SizedBox.expand(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "You are about to abandon the match?",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  SizedBox(height: 15),
                                                  Text(
                                                    "Are you sure?",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  SizedBox(height: 15),
                                                  Container(
                                                    height: 50,
                                                    width: 150,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        ElevatedButton(
                                                          style: ButtonStyle(
                                                              shape: MaterialStateProperty.all(
                                                                  RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30.0))),
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .black)),
                                                          child: Text('Yes'),
                                                          onPressed: () async {
                                                            await MatchServices()
                                                                .abandonMatch(
                                                                    widget.match
                                                                        .matchId);
                                                            widget
                                                                .callbackFunction(
                                                                    'callback');
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        ElevatedButton(
                                                          style: ButtonStyle(
                                                              shape: MaterialStateProperty.all(
                                                                  RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30.0))),
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .black)),
                                                          child: Text('No'),
                                                          onPressed: () => {
                                                            Navigator.of(
                                                                    context)
                                                                .pop()
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Container(),
                          ]),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    convertSportToIcon(
                      widget.match.sport,
                      '',
                      Colors.blue,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 110,
                      // color: Colors.red,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.timelapse),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              widget.match.startingTime,
                              style: TextStyle(color: Colors.white),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 130,
                      // color: Colors.red,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_month),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              widget.match.matchDate,
                              style: TextStyle(color: Colors.white),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 180,
                      // color: Colors.red,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.place),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              widget.match.locationName,
                              style: TextStyle(color: Colors.white),
                            ),
                          ]),
                    ),
                  ],
                ),
              )),
          Positioned(
              left: 15,
              top: 0,
              child: Container(
                // color: Colors.amber,
                height: 153,
                width: 110,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ProfilePic(profilePhoto: widget.match.p1Profile),
                      Text(
                        widget.match.p1Name.split(' ').first +
                            ' , ' +
                            widget.match.p1Age,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        widget.match.p1Country.substring(2),
                      ),
                    ]),
              )),
          Positioned(
              right: 15,
              top: 0,
              child: Container(
                // color: Colors.amber,
                height: 153,
                width: 110,
                child: Column(children: [
                  ProfilePic(profilePhoto: widget.match.p2Profile),
                  Text(
                    widget.match.p2Name.split(' ').first +
                        ' , ' +
                        widget.match.p2Age,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    widget.match.p2Country.substring(2),
                  ),
                ]),
              )),
        ],
      ),
    );
  }
}
