// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:micro_mitti/All_Properties/fullyFunded.dart';
import 'package:micro_mitti/All_Properties/openProperties.dart';
import 'package:micro_mitti/All_Properties/resale.dart';
import 'package:micro_mitti/widget/myWidget.dart';

class AllProperties extends StatefulWidget {
  const AllProperties({Key? key}) : super(key: key);

  @override
  State<AllProperties> createState() => _AllPropertiesState();
}

class _AllPropertiesState extends State<AllProperties>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchDataFromBackend();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<QuerySnapshot<Object?>> fetchDataFromBackend() async {
    try {
      QuerySnapshot stream =
          await FirebaseFirestore.instance.collection('properties').get();
      print('Fetched data: ${stream.docs}');
      return stream;
    } catch (error) {
      print('Error fetching data: $error');
      throw error;
    }
  }

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
            header: 'ALL PROPERTIES',
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
                        'Open',
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
                        'Fully Funded',
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
                OpenProperties(),
                FullFundedProperties(),
                // ResaleProperties()
              ],
            ),
          )
        ],
      ),
    );
  }
}
