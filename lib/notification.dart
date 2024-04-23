// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:micro_mitti/widget/myWidget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationState();
}

class _NotificationState extends State<NotificationScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: drawer(),
      body: Column(
        children: [
          appbar(
            header: 'Notifications',
            iconData2: null,
            onPressed1: () {
              Navigator.of(context).pop();
            },
            onPressed2: () {},
            iconData1: Icons.arrow_back_ios_new,
            fontSize: 18,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 4.5,
              ),
              Container(
                height: 100,
                width: 100,
                child: Image.asset('assets/images/noNotifications.png'),
              ),
              Center(
                child: Text(
                  "      You Currently Have No Notifications.\nWe'll Notify You When Something New Arrives.",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Barlow',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
