import 'package:fitxkonnect/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(15),
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
                        ClipOval(
                          child: Image.asset('assets/images/banu_sport.png',
                              width: 60, height: 60, fit: BoxFit.cover),
                        ),
                        Positioned(
                          bottom: -10,
                          right: -10,
                          child: ClipOval(
                            child: Image.asset('assets/images/login.png',
                                width: 60, height: 60, fit: BoxFit.cover),
                          ),
                        )
                      ],
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Subcategory',
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                          Text('Venta por Libra'),
                          Text('2km de distancia',
                              style: TextStyle(color: kPrimaryColor))
                        ],
                      ),
                    ),
                    Icon(Icons.location_pin, color: kPrimaryColor, size: 50)
                  ],
                )),
            Container(
                child: Column(
              children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                              image: NetworkImage(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiz-TEmkNRlgtW4-AN71SmPZmtLtHXZM4FEQ&usqp=CAU',
                              ),
                              fit: BoxFit.cover),
                          border: Border.all(color: kPrimaryColor, width: 4)),
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Jose Gonzalez',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Autopista Duarte\nCarretera Duarte Vieja')
                      ],
                    )
                  ],
                )
              ],
            ))
          ],
        ));
  }
}
