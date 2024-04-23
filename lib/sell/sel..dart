// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:micro_mitti/All_Properties/fullyFunded.dart';
import 'package:micro_mitti/All_Properties/openProperties.dart';
import 'package:micro_mitti/sell/approved.dart';
import 'package:micro_mitti/sell/prending.dart';
import 'package:micro_mitti/sell/rejected.dart';
import 'package:micro_mitti/widget/myWidget.dart';

class Sell extends StatefulWidget {
  const Sell({super.key});

  @override
  State<Sell> createState() => _SellState();
}

class _SellState extends State<Sell> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: Container(child: Image.asset('assets/images/bottom_layout.png'),),
       bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        child: Image.asset(
          'assets/images/bottom_layout.png',
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          appbar(
            header: 'SELL STATUS',
            iconData1: Icons.arrow_back_ios_new,
            onPressed2: () {},
            onPressed1: () {
              Navigator.of(context).pop();
            },
            fontSize: 18,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 35),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Color(0xFFE4E4E4)),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              // width: MediaQuery.of(context).size.width,
              height: 45,
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: EdgeInsets.all(0),
                  indicator: BoxDecoration(
                    color: Color(0xFFFECC00),
                  ), //
                // indicatorPadding: EdgeInsets.all(0),
                // indicator:
                    // BoxDecoration(color: Color(0xFFFECC00)), // Custom indicator
                controller: _tabController,
                // isScrollable: true,
                // labelPadding: EdgeInsets.symmetric(horizontal: 20),
                tabs: [
                  Tab(
                    child: Container(
                      width: 120,
                      child: Text(
                        'Approved',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF302F2E),
                          fontSize: 12,
                          fontFamily: 'Barlow',
                          fontWeight: FontWeight.w500,
                          height: 0,
                          // letterSpacing: -0.24,
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      width: 120,
                      child: Text(
                        'Rejected',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF302F2E),
                          fontSize: 12,
                          fontFamily: 'Barlow',
                          fontWeight: FontWeight.w500,
                          height: 0,
                          // letterSpacing: -0.24,
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      width: 120,
                      child: Text(
                        'Pending',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF302F2E),
                          fontSize: 12,
                          fontFamily: 'Barlow',
                          fontWeight: FontWeight.w500,
                          height: 0,
                          // letterSpacing: -0.24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Approved(),
                Rejected(),
                Pending()
                // ResaleProperties()
                ],
            ),
          )
        ],
      ),
    );
  }
}
