// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:micro_mitti/widget/myWidget.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Image.asset('assets/images/bottom_layout.png'),
        key: _scaffoldKey,
        drawer: drawer(),
        body: Column(
          children: [
             appbar(
              header: 'ABOUT US',
              onPressed2: () {
                // Get.to(() => NotificationScreen());
              },
              iconData1: Icons.arrow_back_ios,
              onPressed1: () {
                Navigator.of(context).pop();
              },
              fontSize: 18,
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          child: Card(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child:
                                    Image.asset("assets/images/cardimg2.png")),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Center(
                            child: Text(
                              "Welcome to Micro Mitti, Indore's premier Proptech company, revolutionizing the landscape of real estate investments. We empower our investors to stake a claim in prime real estate assets without the hefty price tag or the typical obligations that come with full-fledged property ownership.\n \nHarnessing the synergy of technology and Indore's thriving real estate potential, we provide a seamless online platform for fractional real estate investments. With just a click, investors can make informed decisions, targeting sustainable and long- term wealth accumulation. \n\nJoin us at Micro Mitti, where we are not just another real estate company but a beacon of wealth generation for all.",
                              style: TextStyle(
                                color: Color(0xFF302F2E),
                                fontSize: 18,
                                fontFamily: 'Barlow Condensed',
                                fontWeight: FontWeight.w500,
                                // height: 0.08,
                                letterSpacing: 0.14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
